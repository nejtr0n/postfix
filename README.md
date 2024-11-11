# Postfix
Dockerized postfix service

### ENV
- `POSTFIX_EXTRA_MAIN` - path to extra main.cf config file, which will
  pass through `gomplate` and result will be added to `/etc/postfix/main.cf`
  Example extra_main.cf
  ```
  myhostname = mail.example.ru
  mydomain = example.ru
  myorigin = $mydomain
  mydestination = $myhostname, localhost.$mydomain
  mynetworks = 127.0.0.0/8, 172.17.0.0/16, 10.42.0.0/16, 10.43.0.0/16
  ....
  ```
- `POSTFIX_EXTRA_MASTER` - path to master.cf config file, which will
  pass through `gomplate` and result will be added to `/etc/postfix/master.cf`
  Example extra_master.cf
  ```
  submission inet n - n - - smtpd
   -o smtpd_tls_security_level=encrypt
   -o smtpd_tls_auth_only=yes
   -o smtpd_sasl_auth_enable=yes
   -o smtpd_sasl_type=dovecot
   -o smtpd_sasl_path=inet:127.0.0.1:44111
  ....
  ```