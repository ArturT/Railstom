# Replace * with server IP
<VirtualHost *:80>
  ServerName railstom-production.com

  # Point this to your public folder of rails app
  DocumentRoot /home/rubyuser/rails_apps/railstom-production/current/public

  <LocationMatch "^/assets/.*$">
    Header unset ETag
    FileETag None
    # RFC says only cache for 1 year
    ExpiresActive On
    ExpiresDefault "access plus 1 year"
  </LocationMatch>

  RewriteEngine On

  <Proxy balancer://unicornservers>
    BalancerMember http://127.0.0.1:3000
  </Proxy>

  # Redirect all non-static requests to unicorn
  RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
  RewriteRule ^/(.*)$ balancer://unicornservers%{REQUEST_URI} [P,QSA,L]

  ProxyPassReverse / balancer://unicornservers/
  ProxyPreserveHost on

  <Proxy *>
    Order deny,allow
    Allow from all
  </Proxy>

  # Custom log file locations
  ErrorLog  /home/rubyuser/rails_apps/railstom-production/shared/log/apache-error.log
  CustomLog /home/rubyuser/rails_apps/railstom-production/shared/log/apache-access.log combined
</VirtualHost>
