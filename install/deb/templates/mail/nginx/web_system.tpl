server {
    listen      %ip%:%web_port%;
    server_name %domain% %alias%;
    root /var/lib/roundcube;
    index index.php;

    include %home%/%user%/conf/mail/%root_domain%/nginx.forcessl.conf*;

    location / {
        try_files      $uri $uri/ /index.php?$args;
        location ~* ^.+\.(jpg,jpeg,gif,png,ico,svg,css,zip,tgz,gz,rar,bz2,doc,xls,exe,pdf,ppt,txt,odt,ods,odp,odf,tar,wav,bmp,rtf,js,mp3,avi,mpeg,flv,html,htm)$ {
            alias          /var/lib/roundcube/;
            expires        15m;
        }
    }

    location /error/ {
        alias   %home%/%user%/web/%root_domain%/document_errors/;
    }

    location ~ /(config|temp|logs) {
        return 404;
    }

    location /Microsoft-Server-ActiveSync {
        alias /usr/share/z-push/;

        location ~ ^/Microsoft-Server-ActiveSync/(.*\.php)$ {
            alias /usr/share/z-push/$1;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $request_filename;
        }
    }
    
    location ~ ^/(.*\.php)$ {
        alias /var/lib/roundcube/$1;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $request_filename;
    }
    
    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}

    include %home%/%user%/conf/mail/%root_domain%/%web_system%.conf_*;
}
