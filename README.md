# Jarkom-Modul-2-F12-2023

| Nama | NRP |
| ----------- | ----------- |
| Aurelio Killian Lexi Verrill | 5025211126 |
| Rano Noumi Sulistyo | 5025211185 | 


## Daftar Isi
- [Topologi](#topologi)
- [Konfigurasi](#konfigurasi)
- [Soal 1](#soal-1)
- [Soal 2](#soal-2)
- [Soal 3](#soal-3)
- [Soal 4](#soal-4)
- [Soal 5](#soal-5)
- [Soal 6](#soal-6)
- [Soal 7](#soal-7)
- [Soal 8](#soal-8)
- [Soal 9](#soal-9)
- [Soal 10](#soal-10)
- [Soal 11](#soal-11)
- [Soal 12](#soal-12)
- [Soal 15](#soal-15)

## Topologi
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/efaa7b4a-199d-4b20-ab5c-b1b88f7bf492)

## Konfigurasi
- Router
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.227.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.227.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.227.3.1
	netmask 255.255.255.0
```

- Nakula Client
```
auto eth0
iface eth0 inet static
	address 192.227.1.2
	netmask 255.255.255.0
	gateway 192.227.1.1
```

- Sadewa Client
```
auto eth0
iface eth0 inet static
	address 192.227.1.3
	netmask 255.255.255.0
	gateway 192.227.1.1
```

- Arjuna Load Balancer
```
auto eth0
iface eth0 inet static
	address 192.227.1.4
	netmask 255.255.255.0
	gateway 192.227.1.1
```

- Yudhistira DNS Master
```
auto eth0
iface eth0 inet static
	address 192.227.2.3
	netmask 255.255.255.0
	gateway 192.227.2.1
```

- Werkudara DNS Slave
```
auto eth0
iface eth0 inet static
	address 192.227.2.2
	netmask 255.255.255.0
	gateway 192.227.2.1
```

- Prabukusuma Web Server
```
auto eth0
iface eth0 inet static
	address 192.227.3.2
	netmask 255.255.255.0
	gateway 192.227.3.1
```

- Abimanyu Web Server
```
auto eth0
iface eth0 inet static
	address 192.227.3.3
	netmask 255.255.255.0
	gateway 192.227.3.1
```

- Wisanggeni Web Server
```
auto eth0
iface eth0 inet static
	address 192.227.3.4
	netmask 255.255.255.0
	gateway 192.227.3.1
```

## Soal 1

1. Jalankan command berikut pada router
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.227.0.0/16
```

2. Pada **YudhistiraDNSMaster**, install `bind9` dan masukkan konfigurasi di bawah pada `/etc/resolv.conf`
```
# /etc/resolv.conf

nameserver 192.122.1.1
```
```
apt-get update
apt-get install -y bind9
service bind9 start
```

3. Pada **NakulaClient** dan **SadewaClient**, masukkan konfigurasi berikut pada `/etc/resolv.conf`
```
options rotate
nameserver 192.122.1.1
nameserver 192.227.2.3  # IP YudhistiraDNSMaster
```

## Soal 2
> Buatlah website utama pada node arjuna dengan akses ke arjuna.yyy.com dengan alias www.arjuna.yyy.com dengan yyy merupakan kode kelompok.

1. Pada **YudhistiraDNSMaster**, tambahkan konfigurasi berikut pada `/etc/bind/named.conf.local`
```
zone "arjuna.f12.com" {
        type master;
        file "/etc/bind/arjuna.f12/arjuna.f12.com";
};
```

2. Buat direktori `/etc/bind/arjuna.f12/` kemudian tambahkan konfigurasi di bawah pada file `arjuna.f12.com` di dalam direktori yang baru saja dibuat
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     arjuna.f12.com. root.arjuna.f12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN	    NS	    arjuna.f12.com.
@	    IN	    A	    192.227.1.4
www	    IN	    CNAME	arjuna.f12.com.
@	    IN	    AAAA	::1
```

3. Restart **bind9**

4. Lakukan test pada Client dengan menjalankan command berikut
```
ping arjuna.f12.com
ping www.arjuna.f12.com
```

<p align="center">
  <img src="https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/d056da5f-0d76-4315-baf7-0cc726737a81" alt='Ping arjuna.f12.com' />
</p>

## Soal 3
> Dengan cara yang sama seperti soal nomor 2, buatlah website utama dengan akses ke abimanyu.yyy.com dan alias www.abimanyu.yyy.com.

1. Pada **YudhistiraDNSMaster**, tambahkan konfigurasi berikut pada `/etc/bind/named.conf.local`
```
zone "abimanyu.f12.com" {
        type master;
        file "/etc/bind/abimanyu.f12/abimanyu.f12.com";
};
```

2. Buat direktori `/etc/bind/abimanyu.f12/` kemudian tambahkan konfigurasi di bawah pada file `abimanyu.f12.com` di dalam direktori yang baru saja dibuat
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     abimanyu.f12.com.       root.abimanyu.f12.com. (
                              2                 ; Serial
                         604800                 ; Refresh
                          86400                 ; Retry
                        2419200                 ; Expire
                         604800 )               ; Negative Cache TTL
;
@		IN	    NS	    abimanyu.f12.com.
@		IN	    A	    192.227.3.3
www     IN      CNAME   abimanyu.f12.com.
@		IN	    AAAA	::1
```

3. Restart **bind9**

4. Lakukan test pada Client dengan menjalankan command berikut
```
ping abimanyu.f12.com
ping www.abimanyu.f12.com
```

<p align="center">
  <img src="https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/5a695935-132a-4c91-a4ba-f2b280020f59" alt='Ping abimanyu.f12.com' />
</p>

## Soal 4
> Kemudian, karena terdapat beberapa web yang harus di-deploy, buatlah subdomain parikesit.abimanyu.yyy.com yang diatur DNS-nya di Yudhistira dan mengarah ke Abimanyu.

1. Untuk menambah subdomain **parikesit**.abimanyu.yyy.com, tambahkan `parikesit IN A 192.227.3.3` pada file konfigurasi `/etc/bind9/abimanyu.f12/abimanyu.f12.com` sehingga hasilnya menjadi seperti berikut
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     abimanyu.f12.com.       root.abimanyu.f12.com. (
                              2                 ; Serial
                         604800                 ; Refresh
                          86400                 ; Retry
                        2419200                 ; Expire
                         604800 )               ; Negative Cache TTL
;
@		    IN	    NS	    abimanyu.f12.com.
@		    IN	    A	    192.227.3.3
www         IN      CNAME   abimanyu.f12.com.
parikesit	IN	    A	    192.227.3.3
@		    IN	    AAAA	::1
```

2. Restart **bind9**

3. Lakukan test pada Client dengan menjalankan command berikut
```
ping parikesit.abimanyu.f12.com
```

<p align="center">
  <img src="https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/3ce6e4bd-c1d9-4b4b-ad48-5aa8b38b5333" alt='Ping parikesit.abimanyu.f12.com' />
</p>

## Soal 5
> Buat juga reverse domain untuk domain utama. (Abimanyu saja yang direverse)

1. Buat zone baru pada **YudhistiraDNSMaster** dengan menambahkan konfigurasi di bawah ini pada file `/etc/bind/named.conf.local`
```
zone "3.227.192.in-addr.arpa" {
        type master;
        file "/etc/bind/abimanyu.f12/3.227.192.in-addr.arpa";
};
```

2. Tambahkan konfigurasi di bawah pada file `3.227.192.in-addr.arpa` di dalam direktori `/etc/bind/abimanyu.f12`
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     abimanyu.f12.com.       root.abimanyu.f12.com. (
                              2                 ; Serial
                         604800                 ; Refresh
                          86400                 ; Retry
                        2419200                 ; Expire
                         604800 )               ; Negative Cache TTL
;
3.227.192.in-addr.arpa. IN      NS      abimanyu.f12.com.
3                       IN      PTR     abimanyu.f12.com.
```

3. Restart **bind9**

4. Lakukan test pada Client dengan menjalankan command berikut
```
host -t PTR 192.227.3.3
```

<p align="center">
  <img src="https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/c769f208-014a-4821-8827-a8c6d146765a" alt='Reverse DNS' />
</p>

## Soal 6
> Agar dapat tetap dihubungi ketika DNS Server Yudhistira bermasalah, buat juga Werkudara sebagai DNS Slave untuk domain utama.

1. Edit konfigurasi pada zone `arjuna.f12.com` di **YudhistiraDNSMaster** sehingga menjadi seperti berikut
```
zone "arjuna.f12.com" {
        type master;
        notify yes;
        also-notify { 192.227.2.2; };
        allow-transfer { 192.227.2.2; };
        file "/etc/bind/arjuna.f12/arjuna.f12.com";
};
```

2. Restart **bind9** pada **YudhistiraDNSMaster**

3. Buat zone baru pada `/etc/bind/named.conf.local` di **WerkudaraDNSSlave**
```
zone "arjuna.f12.com" {
        type slave;
        masters { 192.227.2.3; };
        file "/var/lib/bind/arjuna.f12.com";
};
```

4. Restart **bind9** pada **WerkudaraDNSSlave**

5. Matikan **bind9** pada **YudhistiraDNSMaster** atau nodenya kemudian ping dari Client

<p align="center">
  <img src="https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/9e150a8b-7533-477f-a72a-91d09ae41fb5" alt='DNS Slave' />
</p>


## Soal 7
> Seperti yang kita tahu karena banyak sekali informasi yang harus diterima, buatlah subdomain khusus untuk perang yaitu baratayuda.abimanyu.yyy.com dengan alias www.baratayuda.abimanyu.yyy.com yang didelegasikan dari Yudhistira ke Werkudara dengan IP menuju ke Abimanyu dalam folder Baratayuda.

1. Untuk menambah subdomain **baratayuda**.abimanyu.yyy.com, tambahkan konfiguarsi pada `/etc/bind9/abimanyu.f12/abimanyu.f12.com`* di **YudhistiraDNSMaster** sehingga hasilnya menjadi seperti berikut
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     abimanyu.f12.com.       root.abimanyu.f12.com. (
                              2                 ; Serial
                         604800                 ; Refresh
                          86400                 ; Retry
                        2419200                 ; Expire
                         604800 )               ; Negative Cache TTL
;
@           IN	    NS      abimanyu.f12.com.
@           IN	    A       192.227.3.3
www         IN      CNAME   abimanyu.f12.com.
parikesit   IN      A       192.227.3.3
ns1         IN      A       192.227.3.3
baratayuda  IN      NS      ns1
@           IN      AAAA    ::1
```

2. Comment `dnssec-validation auto` dan tambahkan `allow-query{any;};` di bawahnya pada file `/etc/bind/named.conf.options`

3. Tambahkan `allow-transfer { 192.227.2.2; };` pada zone `abimanyu.f12.com` sehingga hasilnya seperti berikut
```
zone "abimanyu.f12.com" {
        type master;
        allow-transfer { 192.227.2.2; };
        file "/etc/bind/abimanyu.f12/abimanyu.f12.com";
};
```

4. Restart **bind9** pada **YudhistiraDNSMaster**

5. Pada **WerkudaraDNSSlave**, buat zone baru pada `/etc/bind/named.conf.local`.
```
zone "baratayuda.abimanyu.f12.com" {
        type master;
        file "/etc/bind/baratayuda/abimanyu.f12.com";
};
```

6. Buat direktori `/etc/bind/baratayuda/` kemudian tambahkan konfigurasi di bawah pada file `abimanyu.f12.com` di dalam direktori yang baru saja dibuat
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     baratayuda.abimanyu.f12.com. root.baratayuda.abimanyu.f12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@         IN      NS      baratayuda.abimanyu.f12.com.
@         IN      A	      192.227.3.3
www       IN      CNAME	  baratayuda.abimanyu.f12.com.
@         IN      AAAA	  ::1
```

7. Comment `dnssec-validation auto` dan tambahkan `allow-query{any;};` di bawahnya pada file `/etc/bind/named.conf.options`

8. Restart **bind9** pada **WerkudaraDNSSlave**

9. Lakukan test pada Client dengan menjalankan command berikut
```
ping baratayuda.abimanyu.f12.com
ping www.baratayuda.abimanyu.f12.com
```

<p align="center">
  <img src="https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/19e5725c-bf1e-4868-9d48-86e3b6cadfed" alt='Delegasi Subdomain' />
</p>

## Soal 8
> Untuk informasi yang lebih spesifik mengenai Ranjapan Baratayuda, buatlah subdomain melalui Werkudara dengan akses rjp.baratayuda.abimanyu.yyy.com dengan alias www.rjp.baratayuda.abimanyu.yyy.com yang mengarah ke Abimanyu.

1. Untuk menambah subdomain **rjp**.baratayuda.abimanyu.yyy.com, tambahkan `rjp IN A 192.227.3.3` dan `www.rjp IN CNAME rjp.baratayuda.abimanyu.f12.com.` pada file konfigurasi `/etc/bind/baratayuda/abimanyu.f12.com` di **WerkudaraDNSSlave** sehingga hasilnya menjadi seperti berikut
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     baratayuda.abimanyu.f12.com. root.baratayuda.abimanyu.f12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@         IN      NS      baratayuda.abimanyu.f12.com.
@         IN      A       192.227.3.3
www       IN      CNAME   baratayuda.abimanyu.f12.com.
rjp       IN      A       192.227.3.3
www.rjp   IN      CNAME   rjp.baratayuda.abimanyu.f12.com.
@         IN      AAAA    ::1
```

2. Restart **bind9**

3. Lakukan test pada Client dengan menjalankan command berikut
```
ping rjp.baratayuda.abimanyu.f12.com
ping www.rjp.baratayuda.abimanyu.f12.com
```

<p align="center">
  <img src="https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/b87d6609-76cf-4431-acf2-a8db947816e4" alt='Subdomain rjp' />
</p>

## Soal 9
Arjuna merupakan suatu Load Balancer Nginx dengan tiga worker (yang juga menggunakan nginx sebagai webserver) yaitu Prabakusuma, Abimanyu, dan Wisanggeni. Lakukan deployment pada masing-masing worker.
1.  download nginx di semua node yang tertulis
```
apt-get update nginx
```
2.  di arjuna /etc/nginx/conf.d buat configurasi load balancer dan buat arjuna.f12.com di /etc/nginx/sites-available
3.  lakukan sym link degan ln -s /etc/nginx/sites-available/arjuna.f12.com /etc/nginx/sites-enabled
## Soal 10
1. edit config load balancer di arjuna
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/114126015/c1bfe2ec-36b0-4e5b-ac17-ad8291132717)
2. edit config di semua worker sesuai dengan port yang digunakan
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/114126015/ea0823ba-2eba-4a86-80df-b87df427c0cc)

## Soal 11
> Selain menggunakan Nginx, lakukan konfigurasi Apache Web Server pada worker Abimanyu dengan web server www.abimanyu.yyy.com. Pertama dibutuhkan web server dengan DocumentRoot pada /var/www/abimanyu.yyy

1. Ubah DocumentRoot menjadi `/var/www/abimanyu.f12` pada `/etc/apache2/sites-available/000-default.conf`
```
DocumentRoot /var/www/abimanyu.f12
```

2. Kemudian download resource untuk website, unzip, dan masukkan ke direktori `/var/www/abimanyu.f12`
```
wget -O '/var/www/abimanyu.f12.com.zip' 'https://drive.usercontent.google.com/download?id=1a4V23hwK9S7hQEDEcv9FL14UkkrHc-Zc'
unzip /var/www/abimanyu.f12.com.zip -d /var/www/
mv /var/www/abimanyu.yyy.com /var/www/abimanyu.f12
rm /var/www/abimanyu.f12.com.zip
```

3. Restart **apache2**

4. Lakukan test pada Client dengan menjalankan command berikut
```
lynx abimanyu.f12.com
```

<p align="center">
  <img src="https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/2abbeddd-b12e-4d4c-9700-80af845bc73b" alt='Subdomain rjp' />
</p>

## Soal 12 
1 edit 000-default confiq
```
Alias /home /var/www/abimanyu.f12/index.php/home
```

## Soal 13
> Selain itu, pada subdomain www.parikesit.abimanyu.yyy.com, DocumentRoot disimpan pada /var/www/parikesit.abimanyu.yyy

1. Ubah DocumentRoot menjadi `/var/www/parikesit.abimanyu.f12` pada `/etc/apache2/sites-available/000-default.conf`
```
DocumentRoot /var/www/abimanyu.f12
```

2. Kemudian download resource untuk website, unzip, dan masukkan ke direktori `/var/www/abimanyu.f12`
```
wget -O '/var/www/abimanyu.f12.com.zip' 'https://drive.usercontent.google.com/download?id=1a4V23hwK9S7hQEDEcv9FL14UkkrHc-Zc'
unzip /var/www/abimanyu.f12.com.zip -d /var/www/
mv /var/www/abimanyu.yyy.com /var/www/abimanyu.f12
rm /var/www/abimanyu.f12.com.zip
```

3. Restart **apache2**

4. Lakukan test pada Client dengan menjalankan command berikut
```
lynx abimanyu.f12.com
```

<p align="center">
  <img src="https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/87407047/2abbeddd-b12e-4d4c-9700-80af845bc73b" alt='Subdomain rjp' />
</p>


## Soal 14
1. tambah config untuk tiap directory untuk file parikesit
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/114126015/4f48dfea-63d4-491d-a057-14ed9ec09fe2)
2. restart apache
## Soal 15 
1. Edit config parikesit untuk error document
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/114126015/fc5694af-af2c-4b3c-9125-887ac1c9e7b3)
## Soal 16
1. edit config parikesit
```
Alias /js /var/www/parikesit.abimanyu.f12/public/js
```
## Soal 17 
1. Download resource untuk rjp di /var/www dan unzip
2. Buat config baru di etc/apache2/sites-available
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/114126015/f3fc6af5-95f7-4ed7-a2cf-108185e013ae)
## Soal 18 
1 buat hatpasswd di /etc/apache2 
```
htpasswd -c /etc/apache2/rjp.passwd Wayang
baratayudaf12
```
2. Edit config rjp
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/114126015/dd26aeb2-b104-4f6e-a319-08baafaa464a)
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/114126015/ea30115f-63cc-4be0-82c1-b1d61db2429a)
## Soal 19
1. buat config sites-available baru untuk ip address
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/114126015/c85c9d0f-3915-4667-a6b5-98ae6e243f44)
## Soal 20 
1. Edit config parikesit untuk rewrite
![image](https://github.com/aurelioklv/Jarkom-Modul-2-F12-2023/assets/114126015/049c6a96-b69e-40b8-aebc-016ea8395f48)
2. tambahkan mod rewrite degnan ae2mod rewrite
3. Restart apache 
