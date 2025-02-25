%% MM anual
clc,clear
data= readtable("Data_Aumentation.xlsx",'Sheet', 'SERIE_EVENTOS',VariableNamingRule='preserve');
data= table2cell(data);
data=data(:,1:2);

codesAndina=[52040160 52050040 52050080 52055220 52050190 52045070 ...
    52030090 52035040 520660040 52010060 51020010 52050110 52070030 ...
    52060050 52050130 47015080 47010230];
codesPacifica=[52065020 51035020 53020010 52070010 53010020 51030020 ...
    51025090 51020050 52090010 53020020];

for i=1:length(data)
    str=split(data{i,2});
    for j=1:length(str)
        part=str(j,:);
        partDouble=str2double(part);
        if (~isnan(partDouble))
            data{i,2}=partDouble;
        end
    end
end

DataPerYear={zeros};
yearsOfStudy=2006:2015;
for i=1:length(yearsOfStudy)
    Temp={zeros}; n=1;
    for j=1:length(data)
        Year=data{j,1}.Year;
        if (Year==yearsOfStudy(i))
            Temp{n,1}=data{j,1};
            Temp{n,2}=data{j,2};
            n=n+1;
        end
    end
    DataPerYear{i}=Temp;
end

%total
eventsPerYear=zeros;
for i=1:length(yearsOfStudy)
    eventsPerYear(i)=length(DataPerYear{i});
end

%andina
eventsPerYearAndina=zeros;
for i=1:length(DataPerYear)
    data=DataPerYear{i};
    n=0;
    for j=1:length(data)
        code=data{j,2};
        if (ismember(code,codesAndina))
            n=n+1;
        end
    end
    eventsPerYearAndina(i)=n;
end

%pacifica
eventsPerYearPacifica=zeros;
for i=1:length(DataPerYear)
    data=DataPerYear{i};
    n=0;
    for j=1:length(data)
        code=data{j,2};
        if (ismember(code,codesPacifica))
            n=n+1;
        end
    end
    eventsPerYearPacifica(i)=n;
end
%% MM mensual
DataPerMonth={zeros};
monthsOfTheYear=1:12;
for i=1:length(DataPerYear)
    Temp0={zeros};
    for j=1:length(monthsOfTheYear)
        Temp1={zeros}; n=1;
        for k=1:length(DataPerYear{i})
            Month=DataPerYear{i}{k,1}.Month;
            if (Month==monthsOfTheYear(j))
                Temp1{n,1}=DataPerYear{i}{k,1};
                Temp1{n,2}=DataPerYear{i}{k,2};
                n=n+1;
            end
        end
        Temp0{j}=Temp1;
    end
    DataPerMonth{i}=Temp0;
end

%total
eventsPerMonth={zeros};
for i=1:length(yearsOfStudy)
    Temp=zeros;
    for j=1:length(monthsOfTheYear)
        Data=DataPerMonth{i}{j};
        if(size(Data,2)>1)
            Temp(j)=length(Data);
        else
            Temp(j)=0;
        end
    end
    eventsPerMonth{i}=Temp;
end

%andina
eventsPerMonthAndina={zeros};
for i=1:length(yearsOfStudy)
    Temp=zeros;
    for j=1:length(monthsOfTheYear)
        Data=DataPerMonth{i}{j};
        if(size(Data,2)>1)
            codes= cell2mat(Data(:,2));
            isMember= ismember(codes,codesAndina);
            Temp(j)=sum(isMember);
        else
            Temp(j)=0;
        end
    end
    eventsPerMonthAndina{i}=Temp;
end

%pacifica
eventsPerMonthPacifica={zeros};
for i=1:length(yearsOfStudy)
    Temp=zeros;
    for j=1:length(monthsOfTheYear)
        Data=DataPerMonth{i}{j};
        if(size(Data,2)>1)
            codes= cell2mat(Data(:,2));
            isMember= ismember(codes,codesPacifica);
            Temp(j)=sum(isMember);
        else
            Temp(j)=0;
        end
    end
    eventsPerMonthPacifica{i}=Temp;
end

temp=[];temp1=[];temp2=[];
for i=1:length(eventsPerMonth)
    temp=[temp, eventsPerMonth{i}];
    temp1=[temp1, eventsPerMonthAndina{i}];
    temp2=[temp2, eventsPerMonthPacifica{i}];
end
eventsPerMonth=temp;
eventsPerMonthAndina=temp1;
eventsPerMonthPacifica=temp2;
%% enso
%mensual
enso= readtable("Data_Aumentation.xlsx",'Sheet', 'ENSOS',VariableNamingRule='preserve');
enso= table2cell(enso);
enso=enso(:,[1,2]);
ensoPerMonth=cell2mat(enso(:,2));

%anual
ensoPerYear=zeros;n=1;
for i = 1:12:length(enso)
    meiPerYear=enso(i:i+11,2);
    meiPerYear=cell2mat(meiPerYear);
    promMeiPerYear=mean(meiPerYear);
    ensoPerYear(n)=promMeiPerYear;
    n=n+1;
end
%% lluvias anual
lluvias=readtable("result_merge_final.csv",VariableNamingRule='preserve');
lluvias=table2cell(lluvias);
lluvias=lluvias(:,1:3);

RainPerYear = cell(length(yearsOfStudy), 1);
for i=1:length(yearsOfStudy)
    Temp = cell(0, 3); n=1;
    for j=1:length(lluvias)
        Year=lluvias{j,1}.Year;
        if (Year==yearsOfStudy(i))
            Temp{n,1}=lluvias{j,1};
            Temp{n,2}=lluvias{j,2};
            Temp{n,3}=lluvias{j,3};
            n=n+1;
        end
    end
    RainPerYear{i}=Temp;
end

%total
mmPerYear=zeros(1,length(yearsOfStudy));
for j=1:length(yearsOfStudy)
    totalRainsPerYear=RainPerYear{j}(:,3);
    totalRainsPerYear=cell2mat(totalRainsPerYear);
    meanRains=mean(totalRainsPerYear);
    mmPerYear(j)=meanRains;
end

% andina
mmPerYearAndina=zeros;
for i=1:length(RainPerYear)
    data=RainPerYear{i};
    sumRain=0;n=0;
    for j=1:length(data)
        code=data{j,2};
        if (ismember(code,codesAndina))
            sumRain=sumRain+data{j,3};
            n=n+1;
        end
    end
    mmPerYearAndina(i)=sumRain/n;
end

%pacifica
mmPerYearPacifica=zeros;
for i=1:length(RainPerYear)
    data=RainPerYear{i};
    sumRain=0;n=0;
    for j=1:length(data)
        code=data{j,2};
        if (ismember(code,codesPacifica))
            sumRain=sumRain+data{j,3};
            n=n+1;
        end
    end
    mmPerYearPacifica(i)=sumRain/n;
end
%% lluvia mensual
RainPerMonth={zeros};
monthsOfTheYear=1:12;
for i=1:length(RainPerYear)
    Temp0={zeros};
    for j=1:length(monthsOfTheYear)
        Temp1={zeros}; n=1;
        for k=1:length(RainPerYear{i})
            Month=RainPerYear{i}{k,1}.Month;
            if (Month==monthsOfTheYear(j))
                Temp1{n,1}=RainPerYear{i}{k,1};
                Temp1{n,2}=RainPerYear{i}{k,2};
                Temp1{n,3}=RainPerYear{i}{k,3};
                n=n+1;
            end
        end
        Temp0{j}=Temp1;
    end
    RainPerMonth{i}=Temp0;
end

%total
mmPerMonth={zeros};
for i=1:length(yearsOfStudy)
    Temp=zeros;
    for j=1:length(monthsOfTheYear)
        Data=RainPerMonth{i}{j}(:,3);
        Data=cell2mat(Data);
        Temp(j)=mean(Data);
    end
    mmPerMonth{i}=Temp;
end

%andina
mmPerMonthAndina={zeros};
for i=1:length(yearsOfStudy)
    Temp=zeros;
    for j=1:length(monthsOfTheYear)
        Data=RainPerMonth{i}{j};
        codes= cell2mat(Data(:,2));
        isMember= ismember(codes,codesAndina);
        filteredData = Data(isMember, :);
        values = cell2mat(filteredData(:, 3));
        meanValues= mean(values);
        Temp(j)= meanValues;
    end
    mmPerMonthAndina{i}=Temp;
end

%pacifica
mmPerMonthPacifica={zeros};
for i=1:length(yearsOfStudy)
    Temp=zeros;
    for j=1:length(monthsOfTheYear)
        Data=RainPerMonth{i}{j};
        codes= cell2mat(Data(:,2));
        isMember= ismember(codes,codesPacifica);
        filteredData = Data(isMember, :);
        values = cell2mat(filteredData(:, 3));
        meanValues= mean(values);
        Temp(j)= meanValues;
    end
    mmPerMonthPacifica{i}=Temp;
end

temp=[];temp1=[];temp2=[];
for i=1:length(mmPerMonth)
    temp=[temp, mmPerMonth{i}];
    temp1=[temp1, mmPerMonthAndina{i}];
    temp2=[temp2, mmPerMonthPacifica{i}];
end
mmPerMonth=temp;
mmPerMonthAndina=temp1;
mmPerMonthPacifica=temp2;
%% graficas
clc ; close all

f1=graficar(eventsPerYear,mmPerYear,ensoPerYear,"anually");
saveas(f1,'NariñoAnual','meta')
f2=graficar(eventsPerYearAndina,mmPerYearAndina,ensoPerYear,"anually");
saveas(f2,'AndinaAnual','meta')
f3=graficar(eventsPerYearPacifica,mmPerYearPacifica,ensoPerYear,"anually");
saveas(f3,'PacificaAnual','meta')
f4=graficar(eventsPerMonth,mmPerMonth,ensoPerMonth,"monthly");
saveas(f4,'NariñoMensual','meta')
f5=graficar(eventsPerMonthAndina,mmPerMonthAndina,ensoPerMonth,"monthly");
saveas(f5,'AndinaMensual','meta')
f6=graficar(eventsPerMonthPacifica,mmPerMonthPacifica,ensoPerMonth,"monthly");
saveas(f6,'PacificaMensual','meta')

function [f1] = graficar(events,rain,enos,type)
yearsOfStudy=2006:2015;
monthsOfTheYear=1:12;
f1= figure;
set(f1,'units','normalized','outerposition',[0 0 1 1])
set(f1, 'Color', 'w');
f1Axes=axes;
f1Axes.XLabel.FontWeight='bold';
if (type=="monthly")
    xAxis=1:120;
    newXAxis=-2:123;
    f1Axes.XLabel.String='Fecha (intervalos mensuales)';
elseif (type=="anually")
    xAxis=yearsOfStudy;
    newXAxis=2003:2018;
    f1Axes.XLabel.String='Año';
end

meanEvents = mean(events) * ones(size(newXAxis));
meanRain = mean(rain) * ones(size(newXAxis));

yyaxis left
f1Left= gca;
mm=bar(f1Axes,xAxis,events,'FaceAlpha',0.6,'FaceColor',[1, 0.5, 0]);
hold(f1Left,'on');
plotMeanEvents=plot(f1Axes,newXAxis,meanEvents,'Color',[1, 0.5, 0],'LineStyle','--','Marker','none');
set(f1Left,'YLim',[0 max(events)+10])
f1Left.YColor='k';
f1Left.YLabel.String='Numero de deslizamientos';
f1Left.YLabel.FontWeight='bold';

yyaxis right
f1Right= gca;
rainP=plot(f1Axes,xAxis,rain,'-k','LineWidth', 1);
[ymax, idx_max] = max(rain);
[ymin, idx_min] = min(rain); 
hold(f1Right, 'on');
plotMeanRain=plot(f1Axes,newXAxis,meanRain,'--k');
text(xAxis(idx_min),ymin-10,[' Min: ' num2str(round(ymin,1))],'FontSize',10,AffectAutoLimits="on");
text(xAxis(idx_max),ymax+10,[' Max: ' num2str(round(ymax,1))],'FontSize',10,AffectAutoLimits="on");

color_nino = 'r'; color_nina = 'b';
umbral_nino= 0.5;umbral_nina= -0.5;
for i = 1:length(enos)
    if enos(i) > umbral_nino
        plot(f1Axes, xAxis(i), rain(i), '-s', ...
            'LineWidth', 1, 'MarkerFaceColor', color_nino, 'Color', 'k');
    elseif enos(i) < umbral_nina
        plot(f1Axes, xAxis(i), rain(i), '-s', ...
            'LineWidth', 1, 'MarkerFaceColor', color_nina, 'Color', 'k');
    else
        plot(f1Axes, xAxis(i), rain(i), '-s', ...
            'LineWidth', 1, 'MarkerFaceColor', 'w', 'Color', 'k');
    end
end

set(f1Right,'YLim',[0 max(rain)+20])
f1Right.YColor='k';
f1Right.YLabel.String='Lluvia promedio [mm]';
f1Right.YLabel.FontWeight='bold';

if (type=="monthly")
    xlabels = {};
    for i = 1:length(yearsOfStudy)
        xlabels{end+1} = sprintf('%d-%02d', yearsOfStudy(i), monthsOfTheYear(1));
    end
    f1Axes.XTick=1:12:120;
    f1Axes.XTickLabel=xlabels;
    f1Axes.XTickLabelRotation=45;
    f1Axes.XLim=[0 121];
elseif (type=="anually")
    f1Axes.XTick = xAxis;
    f1Axes.XTickLabel = yearsOfStudy; 
    f1Axes.XLim=[2005 2016];
end
grid on;
set(gca, 'FontWeight', 'bold', 'LineWidth', 1);

ax2 = axes;
h_nino = plot(ax2,NaN, NaN, 's', 'MarkerFaceColor', color_nino, 'MarkerEdgeColor','k'); 
hold on;
h_nina = plot(ax2,NaN, NaN, 's', 'MarkerFaceColor', color_nina, 'MarkerEdgeColor','k'); 
h_neutro = plot(ax2,NaN, NaN, 's', 'MarkerFaceColor', 'w', 'MarkerEdgeColor','k'); 
ax2.Visible = 'off';

legend(f1Axes,[mm rainP plotMeanEvents plotMeanRain],{'Deslizamientos reportados', 'Precipitación','Promedio de deslizamientos','Promedio de precipitación'}, ... 
    'Location', 'southoutside', 'FontSize', 10 , 'Orientation','horizontal', 'EdgeColor','none','NumColumns',2);
legend(ax2,{'EL NIÑO','LA NIÑA','Neutro'}, 'Location', 'northwest' ...
    , 'FontSize', 10 , 'Orientation','vertical', 'EdgeColor','k');
legend(ax2,'boxon')

end