# Letsencrypt DNSimple Heroku

**WIP WIP WIP**

We could setup on Heroku and renew SSL certificates issued by Letsencrypt using DNSimple via API.
But you need to prepare certificate on DNSimple for specific domain and update CNAME for that custom domain for the first time.

*
* https://devcenter.heroku.com/articles/ssl#change-your-dns-for-all-domains-on-your-app

## What it does

* Fetchs certificate from DNSimple via API
* Adds or updates certificate on Heroku via API

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

Configure environment variables in `.env` or whatever you use:
```bash
DNSIMPLE_TOKEN=
DNSIMPLE_ACCOUNT_ID=
DNSIMPLE_DOMAIN=
HEROKU_TOKEN=
HEROKU_APP=
```

When certificate will be issued on DNSimple you need to run script to setup it to the Heroku application:
```bash
bin/rake letsencrypt:update
```

At this point, you can verify that your application is serving your certificate by running:

```bash
openssl s_client -connect <dns target>:443 -servername <your domain>
# e.g. openssl s_client -connect www.example.com.herokudns.com:443 -servername www.example.com
```

To enable certificate renew install rake task using Heroku daily scheduler.

## Develop

* `bin/build` checks your specs and runs quality tools
* `bin/quality` based on [RuboCop](https://github.com/bbatsov/rubocop)
* `.rubocop.yml` describes active checks


## Credits

Ruby Base is maintained by [Timur Vafin](http://github.com/timurvafin).
It was written by [Flatstack](http://www.flatstack.com) with the help of our
[contributors](http://github.com/fs/ruby-base/contributors).


[<img src="http://www.flatstack.com/logo.svg" width="100"/>](http://www.flatstack.com)
