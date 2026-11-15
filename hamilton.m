%% MATRİS KONTORLÜ
A=input("\nBİR KOMŞULUK MATRİSİ GİRİNİZ:");
if isempty(A)
    fprintf("BOŞ OLMAYAN BİR KOMŞULUK MATRİSİ GİRİNİZ\n");
    return
end
if ~isequal(size(A,1),size(A,2))
    fprintf("GİRİLEN MATRİS KARE OLMALI\n");
    return
end
if ~isequal(A,A')
    fprintf("GİRİLEN MATRİS SİMETRİK OLMALI\n");
    return
end
if any((A(:)~=0) & (A(:)~=1))
    fprintf("KOMŞULUK MATRİSİ SADECE 0 VE 1'LERDEN OLUŞMALI !\n");
    return
end
if any(diag(A)~=0)
    fprintf("GİRİLEN GRAF LOOP İÇERMEMELİ. BASİT GRAF OLMALI\n")
    return
end
%% TRİVİAL DURUM
if isequal(A,[0])
    fprintf("GİRDİĞİNİZ GRAF TRİVİAL HAMİLTON GRAFTIR. HAMİLTON ÇEVRİMİ İÇERMEZ");
    return
end
%% ∀v∈V İÇİN deg(v)>= 2 Mİ ?   
dugum_sayisi=(size(A,1));
dereceler=sum(A,2);
if any(dereceler<2)
    fprintf("GİRDİĞİNİZ GRAF HAMİLTON DEĞİLDİR"); %DERECESİ 2 DEN KÜÇÜK DÜĞÜM İÇERİYORSA HAMİLTON DEĞİLDİR
    return
end
%% BAĞLANTILILIK KONTORLÜ
gezilenler=false(dugum_sayisi,1);
baslangic=find(dereceler==max(dereceler),1);
sira=baslangic;
eleman=1;
gezilenler(baslangic)=true;% BAĞLANTILILIK KONTROLÜ
while eleman<=length(sira)
    u=sira(eleman);
    eleman=eleman+1;
    komsular=find(A(u,:)>0);
    for v=komsular
        if ~gezilenler(v)
            gezilenler(v)=true;
            sira(end+1)=v;
        end
    end
end
if all(gezilenler~=0)%BAĞLANTILIYSA
    fprintf("GİRİLEN GRAF BAĞLANTILIDIR.\n") %TÜM DÜĞÜMLERE ULAŞILABİLMİŞSE
else %BAĞLANTILI DEĞİLSE
    fprintf("GİRİLEN GRAF BAĞLANTILI OLMADIĞI İÇİN HAMİLTON DEĞİLDİR\n");
    return 
end
%% DİRAC TEOREMİ
if ((dugum_sayisi>=3) && all(dereceler>=dugum_sayisi/2)) %DİRAC TEOREMİ 
    fprintf("GİRİLEN GRAF HAMİLTONDUR VE HAMİLTON ÇEVRİMİ İÇERİR\n")
else
    fprintf("DİRAC TEOREMİ SAĞLANMIYOR HAMİLTON OLUP OLMADIĞI KESİN DEĞİL ARAMA ALGORİTMASINA GÖRE BELLİ OLACAK");
end
%% ÇEVRİM BULMA
n=dugum_sayisi;
start=baslangic;
cevrim=zeros(1,n+1); %N+1 ELEMANLI 0'LARDAN OLUŞAN BİR DİZİ OLUŞTURDUM DÖNGÜ DOLAŞTIKÇA 0'LARIN YERİNE DÜĞÜMLER GELECEK
visited=false(1,n);%N ADET DÜĞÜMÜN HEPSİNİ FALSE OLARAK İŞARETLEDİM İLK ETAPTA
siradaki_dugum=ones(1,n+1);%BURADAKİ ESAS HİKAYE BU DEĞİŞKEN GERİYE DÖNDÜĞÜMÜZDE NEREYE GİDECEĞİMİZE BU KARAR VERİYOR 
cevrim(1)=start;% YOLUN İLK DÜĞÜMÜ OLARAK BAŞLANGIÇ DÜĞÜMÜNÜ KOYDUK
visited(start)=true;%BAŞLANGIÇ DÜĞÜMÜNÜ GEZİLDİ OLARAK İŞARETLEDİM
cevrim_bulundu=false;% ÇEVRİMİN BULUNUP BULUNMADIĞINI TUTAN BOOLEAN DEĞİŞKENİ BURDA AMAÇ BU TRUE OLUNCA DÖNGÜDEN ÇIKMAK.
stack=2;
while stack>=2 %STACK 2 VEYA BÜYÜKKEN DÖNECEK ÇÜNKÜ 1. ELEMAN ZATEN SEÇİLİ BİZ 2 DEN İTİBAREN ARIYORUZ
    u=cevrim(stack-1);
    komsular=find(A(u,:)==1);
    i=siradaki_dugum(stack);
    dugum_bulundu=false;
    while i<=length(komsular) %İ KOMŞU SAYISINDAN BÜYÜK OLURSA ÇALIŞMAYI DURDURUR
        v=komsular(i); 
        if ~visited(v)%SEÇİLEN İ. KOMŞU ZİYARET EDİLMEMİŞSE BU BLOĞA GİR BURDAN İSE DUGUM_BULUNDU BLOĞUNA
            visited(v)=true;
            cevrim(stack)=v;
            siradaki_dugum(stack)=i+1;
            dugum_bulundu=true;
            break
        end
        i=i+1;%SEÇİLEN KOMŞU DAHA ÖNCE ZİYARET EDİLMİŞSE İ Yİ 1 ARTTIRARAK DİĞER KOMŞUYU DENEMEYE GEÇ
    end
    if dugum_bulundu %DÜĞÜM BULUNDUYSA
        if stack==n %ÇEVRİM N+1. ELEMANA GELDİYSEM
            if A(cevrim(n),start)==1 %ÇEVRİM TAMAMLANDIYSA
                cevrim(n+1)=start;
                cevrim_bulundu=true;
                break
            else % ÇEVRİM OLUŞTURULAMADIYSA SON ELEMANI ÇEVRİMDEN ÇIKAR ZİYARET EDİLMEDİ OLARAK İŞARETLE
                visited(cevrim(stack))=false;
                cevrim(stack)=0;
            end
        else %TÜM DÜĞÜMLER HENÜZ ÇEVRİME EKLENMEMİŞSE
            stack=stack+1;
            siradaki_dugum(stack)=1;
        end
    else %DÜĞÜM BULUNMADIYSA(GERİ DÖNME MEKANİZMASI)
        siradaki_dugum(stack)=1;
        stack=stack-1;
        if stack>=2
            visited(cevrim(stack))=false;
            cevrim(stack)=0; 
        end
    end
end
%% ÇİZİM 
if cevrim_bulundu
    fprintf("\nHAMILTON ÇEVRİMİ BULUNDU:\n");
    disp(cevrim);

    G = graph(A);
    figure;
    p = plot(G);
    title("Hamilton Çevrimi");

    hold on
    for k = 1:length(cevrim)-1
        highlight(p, cevrim(k), cevrim(k+1), 'LineWidth', 2,'EdgeColor','red');
        pause(1)
    end
    hold off
else
    fprintf("\nHAMİLTON ÇEVRİM BULUNAMADI.\n");
end

