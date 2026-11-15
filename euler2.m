%% MATRİS KONTORLÜ
A=input("BİR KOMŞULUK MATRİSİ GİRİNİZ:\n");
if isempty(A)
    fprintf("BİR KOMŞULUK MATRİSİ GİRMENİZ GEREKMEKTEDİR\n");%MATRİS BOŞ OLMAMALI
    return
end
if ~isequal(size(A,1),size(A,2))
    fprintf("GİRDİĞİNİZ MATRİS KARE OLMALI\n");
    return
end
if ~isequal(A,A')
    fprintf("GİRDİĞİNİZ MATRİS SİMETRİK OLMALI !\n");
    return
end

if any((A(:)~=0) & (A(:)~=1))
    fprintf("KOMŞULUK MATRİSİ SADECE 0 VE 1'LERDEN OLUŞMALI !\n");
    return
end
if any(diag(A)~=0)
    fprintf("GİRDİĞİNİZ GRAF DÖNGÜ İÇERMEMELİ BU ALGORİTMA SADECE BASİT GRAFLAR İÇİN ÇALIŞIR\n");
    return
end
%% TRİVİAL DURUM
dugum_sayisi=size(A,1);
dereceler=sum(A,2);
if all(dereceler==0)
    if dugum_sayisi==1
        fprintf("GİRDİĞİNİZ GRAF TRİVİAL BİR EULER GRAFTIR\n");
        return
    else
        fprintf("GİRDİĞİNİZ GRAF EULER GRAF DEĞİLDİR\n");
        return
    end
end
%% DERECELERLE İLGİLİ KONTORLLER

if any(dereceler<2 & dereceler~=0)
    fprintf("GİRDİĞİNİZ GRAFIN HERHANGİ BİR DÜĞÜMÜNÜN DERECESİ 1 OLMAMALI\n");%DÖNGÜ İÇEREBİLMESİ İÇİN
    return
end
if any(mod(dereceler,2)~=0)
    fprintf("TEK DERECEYE SAHİP DÜĞÜM İÇERDİĞİ İÇİN EULER DEĞİLDİR\n");%TÜM DERECELER ÇİFT OLMALI
    return
end
%% BAĞLANTILILIK
gezilenlenler=false(dugum_sayisi,1);
baslangic=find(dereceler(:)>0,1);
sira=baslangic;
eleman=1;
gezilenlenler(baslangic)=true;
while eleman <= length(sira)
    u=sira(eleman);
    eleman=eleman+1;
    komsular=find(A(u,:)>0);
    for v=komsular
        if ~gezilenlenler(v)
            gezilenlenler(v)=true;
            sira(end+1)=v;
        end
    end
end
if any((dereceler~=0) & ~gezilenlenler)%DERECESİ 0 OLMAYIP ULAŞAMDAIĞIM HERHANGİ BİR DÜĞÜM VARSA GRAF EULER DEĞİLDİR.
    fprintf("GİRDİĞİNİZ GRAF BAĞLANTILI OLMADIĞI İÇİN EULER DEĞİLDİR\n");
    return
end
fprintf("GİRDİĞİNİZ GRAF EULER GRAFTIR\n");
%% HİERHOLZER
copyA=A;
stack=baslangic;
cevrim=[];
while ~isempty(stack)
    u=stack(end);
    v=find(copyA(u,:)>0,1);
    if ~isempty(v)
        copyA(u,v)=0;
        copyA(v,u)=0;
        stack(end+1)=v;

    else
        cevrim(end+1)=u;
        stack(end)=[];

    end
end
%% ÇİZİM
cevrim=fliplr(cevrim);
disp(cevrim);
G=graph(A);
figure;
p = plot(G, 'Layout', 'force');
title("Euler Çevrimi");
highlight(p, unique(cevrim), 'NodeColor', 'k');
for i = 1:length(cevrim)-1
    highlight(p, [cevrim(i) cevrim(i+1)], 'EdgeColor', 'red', 'LineWidth', 2);
    pause(1);

end

