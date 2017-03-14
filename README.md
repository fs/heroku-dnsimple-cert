# Upload Certificate from DNSimple to Heroku

This gem provides `heroku-dnsimple-cert` executable script to upload SSL certificate from DNSimple to Heroku application.

## What it does

* Fetch certificate from DNSimple via API
* Add or update certificate on Heroku via API

## How to prepare

Issue certificate on DNSimple for the first time and enable auto-renew:
https://support.dnsimple.com/articles/ordering-lets-encrypt-certificate/

Change your DNS for domain on your app `www.yourdomainname.com.herokudns.com`:
https://devcenter.heroku.com/articles/ssl#change-your-dns-for-all-domains-on-your-app

Generate Heroku auth token:
```bash
heroku plugins:install heroku-cli-oauth
heroku authorizations:create -d "letsencrypt-heroku"
```

Generate DNSimple auth token:
https://support.dnsimple.com/articles/api-access-token/

## Installation

When certificate will be issued on DNSimple you need to run script to setup it to the Heroku application:

```bash
heroku-dnsimple-cert update \
  --dnsimple-account-id=DNSIMPLE_ACCOUNT_ID \
  --dnsimple-common-name=DNSIMPLE_COMMON_NAME \
  --dnsimple-domain=DNSIMPLE_DOMAIN \
  --dnsimple-token=DNSIMPLE_TOKEN \
  --heroku-app=HEROKU_APP \
  --heroku-token=HEROKU_TOKEN
```

You can configure these environment variables in `.env` or whatever you use,
so that `heroku-dnsimple-cert` will use them by default:

```bash
DNSIMPLE_TOKEN=
DNSIMPLE_ACCOUNT_ID=
DNSIMPLE_DOMAIN=
DNSIMPLE_COMMON_NAME=
HEROKU_TOKEN=
HEROKU_APP=
```

At this point, you can verify that your application is serving your certificate by running:

```bash
openssl s_client -connect <dns target>:443 -servername <your domain>
# e.g. openssl s_client -connect www.example.com.herokudns.com:443 -servername www.example.com
```

## Auto-renewal

To enable certificate renew:

1. Add `gem "heroku_dnsimple_cert"` into `Gemfile`
2. Bunstab executable `bundle binstubs heroku_dnsimple_cert`
3. Setup required env variables on Heroku 
4. Add *Daily Job* to Heroku Scheduler: `if [ "$(date +%d)" = 01 ]; then bin/heroku-dnsimple-cert update; fi`

## Develop

* `bin/build` checks your specs and runs quality tools
* `bin/quality` based on [RuboCop](https://github.com/bbatsov/rubocop)
* `.rubocop.yml` describes active checks


## Credits

Ruby Base is maintained by [Timur Vafin](http://github.com/timurvafin).
It was written by [Flatstack](http://www.flatstack.com) with the help of our
[contributors](http://github.com/fs/ruby-base/contributors).


[<img src="http://www.flatstack.com/logo.svg" width="100"/>](http://www.flatstack.com)
