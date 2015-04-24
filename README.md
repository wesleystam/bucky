# Bucky

Bucky is intended to provide some default configuration for your Rails app when using Buckaroo as a Payment Provider. It currently only talks to the [NVP endpoint].

[NVP endpoint]: http://support.buckaroo.nl/nl/index.php/NVP_Koppeling

Bucky has opinionated defaults and is intended to be used with explicitness in mind.
In stead of doing magic Bucky tries to take care of the hard parts and provide you with a clear API.

Please use [GitHub Issues] to report bugs.

[GitHub Issues]: https://github.com/sajoku/bucky/issues

## Installation

Bucky is tested against Rails 4.2.1.
It has some dependencies which are:
* httparty
* rails
* addressable

Add this line to your application's Gemfile:

```ruby
gem 'bucky'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bucky

## Usage

### Setup

Create an initializer in app/initializers/ which calls Buckaroo::Config.configure.
Websitekey and Secret are two variables that need to be present.
You can find these in your Buckaroo dashboard.

```initializers/buckaroo.rb```

``` ruby
Buckaroo::Config.configure(
  endpoint: "https://testcheckout.buckaroo.nl/nvp/",
  secret: "very-secret",
  websitekey: "very-secure"
)
```

You might want to create separate configurations for different environments
``` ruby
if Rails.env.production?
  Buckaroo::Config.configure(
      endpoint: "https://checkout.buckaroo.nl/nvp/",
      secret: "very-secret-production",
      websitekey: "very-secure-production"
      )
elsif Rails.env.development?

  Buckaroo::Config.configure(
      endpoint: "https://testcheckout.buckaroo.nl/nvp/",
      secret: "very-secret",
      websitekey: "very-secure"
      )
else
  Buckaroo::Config.configure(
      endpoint: "https://testcheckout.buckaroo.nl/nvp/",
      secret: "very-secret-test",
      websitekey: "very-secure-test"
      )
end
```

### Creating a transaction request

Your next step is to create a transaction request which will return a raw response. You can either choose to parse the response with Bucky or parse this  yourself. examples!

```ruby
    def do_it_yourself
    provider = Buckaroo::Main.new(transaction_request_parameters)
    raw_response = provider.post_transaction_request
    end

    # These are the minimal keys and values you need to send.
    #
    # You can omit the brq_return, brq_returnreject, brq_returncancel, brq_returnerror if you have configured these in the Buckaroo dashboard.
    def transaction_request_parameters
      {
        brq_amount:         1.0,
        brq_currency:       "EUR",
        brq_invoicenumber:  46,
        brq_description:    "order 46",
        brq_return:         "http://localhost:3000/transactions/46/callback_success",
        brq_returnreject:   "http://localhost:3000/transactions/46/callback_reject",
        brq_returncancel:   "http://localhost:3000/transactions/46/callback_cancel",
        brq_returnerror:    "http://localhost:3000/transactions/46/callback_error",
        brq_continue_on_incomplete: "RedirectToHTML" #Or no to redirect to html
      }
    end

This returns:
```
      "BRQ_ACTIONREQUIRED=redirect&BRQ_AMOUNT=123.00&BRQ_APIRESULT=ActionRequired&BRQ_CURRENCY=EUR&BRQ_DESCRIPTION=order+46&BRQ_INVOICENUMBER=46&BRQ_MUTATIONTYPE=NotSet&BRQ_REDIRECTURL=https%3a%2f%2ftestcheckout.buckaroo.nl%2fhtml%2fredirect.ashx%3fr%3d82CBA1A6EDC245C0B5D48CD38DF0CF32&BRQ_STATUSCODE=790&BRQ_STATUSMESSAGE=Pending+input&BRQ_TEST=true&BRQ_TIMESTAMP=2015-04-24+11%3a31%3a35&BRQ_TRANSACTIONS=E56EC0D0BC614F958486BC87F97D997A&BRQ_WEBSITEKEY=very-secure&BRQ_SIGNATURE=614e5d6df26e5995e25aa8deb9e0ca9c745e009d"

Or let Bucky handle the parsing for you:
``` ruby
    def let_bucky_do_it
      provider = Buckaroo::Main.new(params)
      raw_response = provider.post_transaction_request
      parsed_response = Buckaroo::Response.new(raw_response)
    end
```

`Buckaroo::Response` parses the response and adds some convenience methods.
`parsed_response.redirect_url`
Returns the url which the user (person that's paying) needs to be redirected to.

`parsed_response.status`
Status code of the transaction requests. Find the different statuses in `Constants.rb`.

`parsed_response.human_readable_status`
Just like the regular status except Bucky matched the human readable string from `Constants.rb`.


### Callbacks

Once the user completes a transaction, Buckaroo will callback your app which can be success, reject, failure or cancel. You need to validate the response and check the status of the payment.
Bucky provides `Buckaroo::Signature.valid?(params)` to check if the signature returned by Buckaroo actually matches the one Bucky calculates. Check out `Signature.rb` on how this gets done.

If the signature is correct your app needs to update/cancel the transaction/payment. Although Buckaroo posts to callback_success it's easy to double check the response for status success.
`Buckaroo::PaymentResponse.new(params).successful_payment?`


### Putting it all together

Your final implementation could look something like this:

``` ruby
class PaymentProvider

  def initialize(transaction)
    @transaction = transaction
  end

  def create_transaction_request
    provider = @Buckaroo::Main.new(params)
    result = provider.post_transaction_request
    Buckaroo::Response.new(result)
  end

  private

  attr_reader :transaction

  def transaction_request_parameters
    {
      brq_amount:         transaction.amount_cents.to_f / 100,
      brq_currency:       transaction.currency,
      brq_invoicenumber:  transaction.id,
      brq_description:    "order #{transaction.id}",
      brq_return:         callback_success_transaction_url(transaction.id),
      brq_returnreject:   callback_reject_transaction_url(transaction),
      brq_returncancel:   callback_cancel_transaction_url(transaction),
      brq_returnerror:    callback_error_transaction_url(transaction),
      brq_continue_on_incomplete: "RedirectToHTML"
    }
  end

end
```

```ruby
class TransactionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :require_valid_signature

  def callback_success
    if Buckaroo::PaymentResponse.new(params).successful_payment?
      transaction = Transaction.find(params[:id])
      transaction.update_attributes!(accepted_at: DateTime.now)

      redirect_to root_path
    end
  end

  # Since the error and cancel response are very similar you can choose to handle these
  # with a single method. It's easy to just create separate actions for these callbacks.
  def callback_reject
    transaction = Transaction.find(params[:id])

    transaction.update_attributes!(rejected_at: DateTime.now)

    redirect_to root_path
  end
  alias_method :callback_error, :callback_reject
  alias_method :callback_cancel, :callback_reject

  private

  # Check  the signature before every action
  def require_valid_signature
    unless Buckaroo::Signature.valid?(params)
      render status: 422, nothing: true
    end
  end

end
```

``` ruby
  resources :transactions, only: :none do
    member do
      post :callback_success
      post :callback_reject
      post :callback_cancel
      post :callback_error
    end
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/bucky/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
  5. Create a new Pull Request

### Thank you

A big thanks to:
* [Daniel Willemse](https://github.com/danielwillemse).For writing the initial implementation.
* The [buckaroo-ideal](https://github.com/eet-nu/buckaroo-ideal) gem. I "borrowed" the configuration class. And peeked at some implementation details.

