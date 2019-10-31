# Configurando *Domain Name Server* - DNS

Este repositório contém os arquivos **básicos** necessários para a configuração de um serviço DNS utilizando o Bind9.
 
## Getting started

#### Instalando o bind9 em Sistemas Debian-based

```# apt-get update ; apt-get install bind9 ```

Todos os arquivos de configuração se encontram no diretório `/etc/bind `

```# cd /etc/bind/ ```

Neste repositório, o arquivo `named.conf.local` é utilizado para declarar as zonas direta e reversa. Usar editor de preferencia (nesse exemplo usamos o *vim*).

```# vim named.conf.local```

Para comentar uma linha neste arquivo, usa-se o `//`. Seguem as zonas criadas neste exemplo.


```
// Zona de Pesquisa Direta

zone "dns.edu.br" {
        type master;
        file "/etc/bind/zones/dns.edu.br";
        };

// Zona de Pesquisa Reversa

zone "26.168.192.in-addr.arpa" {
        type master;
        file "/etc/bind/zones/192.rev";
        };

// Zona de Pesquisa reversa IPV6

zone    "9.c.2.1.d.5.d.f.ip6.arpa" {
        type master;
        file    "/etc/bind/zones/fd5d.12c9.rev";
        };

```

Por organização, criei um diretório `/zones` para os arquivos das zonas. 

```# cd /etc/bind/zones/ ```

Nosso arquivo de zona direta é o `dns.edu.br`. Utilizamos tipo A para os endereços IPv4 e AAAA para os IPv6.

``` 
$TTL    604800
@       IN      SOA     server.dns.edu.br. root.dns.edu.br. (
                         2018103101     ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;

dns.edu.br.     IN      NS      server.dns.edu.br.
dns.edu.br.     IN      A       192.168.26.130
                IN      AAAA    fd5d:12c9:2201:1::254
;-----------------------------------------------------------------
server          IN      A       192.168.26.130
server          IN      AAAA    fd5d:12c9:2201:1::254

cliente         IN      A       192.168.26.139
                IN      AAAA    fd5d:12c9:2201:1:5191:a00b:d863:9efc
teste           IN      A       192.168.26.137

dns             IN      AAAA    2001:db8:1ab:16::3
                IN      A       192.168.26.136

; ----------------    Rede 10.30.0 ----------------------------

host      IN      A       10.30.0.121

; -----------------   CNAMES   ---------------------------------

cliente-pc      IN      CNAME   cliente

```

Zona de pesquisa reversa:

```
$TTL    604800
@       IN      SOA     server.dns.edu.br. root.dns.edu.br. (
                         2018103101     ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      server.

130     IN      PTR     server.dns.edu.br.
137     IN      PTR     teste.dns.edu.br.
139     IN      PTR     cliente.dns.edu.br.

;4.5.2.0.0.0.0.0.0.0.0.0.0.0.0.0.1.0.0.0.1.0.2.2.9.c.2.1.d.5.d.f.ip6.arpa   IN PTR server.dns.edu.br.

 ```
Para finalizar, verifique se o bind9 está executando normalmente

`# service bind9 status`

Se estiver tudo Ok deverá retornar `active (running)` como no exemplo:

```
root@teste:/home/server# service bind9 status
● bind9.service - BIND Domain Name Server
   Loaded: loaded (/lib/systemd/system/bind9.service; enabled; vendor preset: enabled)
  Drop-In: /run/systemd/generator/bind9.service.d
           └─50-insserv.conf-$named.conf
   Active: active (running) since Wed 2018-11-21 05:22:49 PST; 4h 15min ago
     Docs: man:named(8)
 Main PID: 1008 (named)
   CGroup: /system.slice/bind9.service
           └─1008 /usr/sbin/named -f -u bind

Nov 21 05:22:50 teste named[1008]: zone 127.in-addr.arpa/IN: loaded serial 1
Nov 21 05:22:50 teste named[1008]: zone 9.c.2.1.d.5.d.f.ip6.arpa/IN: loaded serial 2018103101
Nov 21 05:22:51 teste named[1008]: zone localhost/IN: loaded serial 2
Nov 21 05:22:51 teste named[1008]: zone 255.in-addr.arpa/IN: loaded serial 1
Nov 21 05:22:51 teste named[1008]: zone 26.168.192.in-addr.arpa/IN: loaded serial 2018103101
Nov 21 05:22:51 teste named[1008]: zone lsd.edu.br/IN: loaded serial 2018103101
Nov 21 05:22:51 teste named[1008]: all zones loaded
Nov 21 05:22:51 teste named[1008]: running
Nov 21 05:22:51 teste named[1008]: zone 26.168.192.in-addr.arpa/IN: sending notifies (serial 2018103101)
Nov 21 05:22:51 teste named[1008]: zone 9.c.2.1.d.5.d.f.ip6.arpa/IN: sending notifies (serial 2018103101)
root@teste:/home/server# 


```

Caso o serviço esteja inativo, tente o seguinte comando:

`# service bind9 start` 

Ou utilizando o `systemctl` para sistemas com o systemd:

`# systemctl start bind9 ` 

`# systemctl enable bind9 `

`# systemctl restart bind9 ` 



