# hosts/ — Hedef Sistem Tanımları

Bu dizin, farklı hedef makineler ve imajlar (canlı ISO, geliştirici iş istasyonu, test sanal makineleri) için ana yapılandırma profillerini barındırır.
İlgili sistem modüllerini, disk şemalarını ve donanım gereksinimlerini bir araya getirerek somut NixOS konfigürasyonlarını türetir.
Her ana makine tanımı tek bir doğruluk kaynağı üzerinden yönetilir.
