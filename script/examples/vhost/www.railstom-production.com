<VirtualHost *:80>
  ServerName www.railstom-production.com
  Redirect permanent / http://railstom-production.com/
</VirtualHost>
