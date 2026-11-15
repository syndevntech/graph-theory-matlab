girdi=input("BİR DERECE DİZİSİ GİRİNİZ:","s");%KULLANICIDAN GİRDİ İSTİYORUM
dizi=str2num(girdi);%ALDIĞIM GİRDİLERİ SAYILARDAN OLUŞAN MATRİSE VEKTÖRÜ ÇEVİRDİM      
dereceler=dizi(:);%KULLANICIDAN ALDIĞIM DERECE DİZİSİNİ SÜTUN VEKTÖRÜNE ÇEVİRDİM ÇÜNKÜ İNDEKSLEME İŞLEMİ İÇİN KOLAYLAŞTIRICI BİR PROCESS
dugum=(1:numel(dereceler))'; %BURDA DÜĞÜM ÜRETTİM NUMARALARIYLA BERABER 1 NUMARADAN ELEMAN SAYISINCI NUMARAYA KADAR NUMARALARLA DÜĞÜMLERİ ADLANDIRDIM VE TRANSPOZ ALDIM ÇÜNKÜ NUMARALARI DERECELERLE SHİPLEMEK İÇİN SÜTUN MATRİSİ İŞİMİ KOLAYLAŞTIRACAK
S=[];%KENAR BAŞLANGIÇ LİSTESİ
T=[];%KENAR BİTİŞ LİSTESİ


if isempty(dereceler)
    fprintf("BOŞTAN FARKLI BİR DERECE DİZİSİ GİRİNİZ") %DERECE DİZİSİNİN BOŞ OLUP OLM. KONTROL ETTİM
    return
end
if any(mod(dereceler,1)~=0)
    fprintf("TAM SAYILARDAN OLUŞAN BİR DERECE DİZİSİ GİRİNİZ");%DERECE DİZİSİNDE TAM SAYI OLMAYAN ELEMAN OLUP OLM. KONTROL ETTİM
    return
end
n=numel(dereceler);

if any(dereceler<0)
    fprintf("GİRDİĞİNİZ DERECE DİZİSİ GRAF BELİRTMEZ") %DERECE DİZİSİNDE NEGATİF ELEMAN OLUP OLM. KONTROL EDİLİYOR
    return
end

if mod(sum(dereceler),2)~=0
    fprintf("GİRDİĞİNİZ DERECE DİZİSİ GRAF BELİRTMEZ");%DERECE DİZİSİNDEKİ ELEMANLARIN TOPLAMININ ÇİFT OLUP OLM KONTROL EDİLİYOR
    return
end

if numel(dereceler)-1<max(dereceler)
    fprintf("GİRDİĞİNİZ DERECE DİZİSİ GRAF BELİRTMEZ");%DERECE DİZİSİNDEKİ HERHANGİ BİR ELEMANIN DEĞERİNİN ELEMAN SAYISINDAN KÜÇÜK OLUP OLM. KONTORL EDİLİYOR
    return
end


while true
[dereceler,indeksler]=sort(dereceler,"descend");%SIRALARKEN DÜĞÜM-DERECE İLİŞKİLERİNİN BOZULMAMASI İÇİN İNDEKSLERİ GÖZ ÖNÜNDE BULUNDURARAK SIRALIYORUZ 
dugum=dugum(indeksler);%DÜĞÜM LİSTESİNİ İNDEKSLERE GÖRE SIRALADIM Kİ DERECE-DÜĞÜM İLİŞKİLERİ BOZULMASIN
    if all(dereceler==0)
        fprintf("BU DERECE DİZİSİ GRAF BELİRTİR") %TÜM DERECELER 0 İSE DÖNGÜYE GİRMEDEN DİREK ÇİZİME GEÇEBİLİRİM
        break
    end
    max_derece=dereceler(1);%BURDA EN BÜYÜK DERECEYİ VE BU DERECEYE SAHİP DÜĞÜMÜN NUMARASINI DEĞİŞKENLERE KAYDEDİYORUM(AZALTMA İŞLEMİ YAPARKEN BUNLARI KULLANICAZ) DAHA SONRA HAVEL HAKİMİ MANTIĞINA UYGUN OLARAK BU DERECEYİ VE BU DERECEYE SAHİP DÜĞÜMÜ LİSTEMDEN ATIYORUM
    max_dugum=dugum(1);
    dereceler(1)=[];
    dugum(1)=[];
    if max_derece>numel(dereceler)
        fprintf("GİRDİĞİNİZ DERECE DİZİSİ GRAF BELİRTMEZ")%BURADA EN BÜYÜK DERECENİN DİZİDEKİ ELEMAN SAYISINDAN BÜYÜK OLUP OLM. KONTORL EDİYORUM BÜYÜKSE ALGORİTMA İPTAL 
        return
    end
    for i=1:max_derece%BURDA İ DİZİ İÇİNDE 1. ELEMANDAN MAX ELEMANINCI ELEMANA KADAR DOLANACAK VE HEPSİNİ 1 AZALTACAK  
        dereceler(i)=dereceler(i)-1;%BURADA İSE NEGATİF ELEMAN OLUP OLM KONTROL EDECEK HERHANGİ BİR ELEMANININ NEGATİF OLMASI DURUMUNDA HAVEL-HAKİMİ ALGORİTMASI ÇÖKER
        if dereceler(i)<0
            fprintf("GİRDİĞİNİZ DERECE DİZİSİ GRAF BELİRTMEZ")
            return
        end
    
    S=[S;max_dugum];%DÜĞÜM KÜMELERİ. HER ADIMDA MAX DÜĞÜM DERECE ADEDİ KADAR DÜĞÜME BAĞLANACAK 
    T=[T;dugum(i)];
    
    end

end

G=graph(S,T,[],n);
figure;
plot(G,"Layout","force")
title("HAVEL-HAKİMİ KULLANARAK GRAF ÇİZİMİ")
