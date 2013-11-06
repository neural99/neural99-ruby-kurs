RubyCamping
Program för administration av Ruby Camping
Version 3
Av: Daniel Lännström

Användning:
Starta programmet i konsolen med ruby main.rb
Välj menyalternativ i huvudmenyn och följ de interaktiva instruktionerna.

Systembeskrivning:
Programmet kan nu hantera olika typer av uthyrning (stuga, husvagn, husbil,
tält).

Kostnad för besöket räknas ut vid utcheckning. Man kan även få en lista
över transaktioner och få en summering av intäkterna på Ruby Camping.

Jag tog bort de 5 gästerna systemet tidigare startade med.  

Användaren kan trycka EOF (Ctrl-D) för att avbryta och komma tillbaka till menyn.

config.rb innehåller konstanter för att enklare kunna lägga till ytterligare
uthyrningsklasser.

Diskussion: 
Jag har utvidgat klasshierakin ordentligt. Istället för att använda if-satser
har jag försökt använda polymorfi. Men speciellt i samband med in- och utmatning
har jag svårt att bli av med if-satser på det sättet. Det blir lätt nästlade loopar
och if-satser i varandra, och jag förstår att det inte är bra Rubyism. Det är inte
heller lätt att använda funktionella metoder för att uppnå detta.  

Jag valde att ta bort de 5 inbyggda test-gästerna, eftersom jag kände att de
var ivägen. Det finns, vad jag ser, ingen referns till dessa i labbspecen så
jag är så bekväm att jag antar att jag inte behöver dem.

Jag har gjort antagandet att gästerna som betala det priset som var aktuellt
när de checkade in, inte det priset som är aktuellt när de checkar ut. Om det
inte ska vara så är det trivialt att ändra det, genom att låta bli att kopiera
PriceList-objektet.

Alternativt skulle man kunna flytta ut logiken kring prisplanen och göra det
till en egen klass. Ska man ha minigolf på Ruby Camping vill man kanske ha ett
prisalternativ för "Tält + minigolf". Det finns också potential att utvidga det
systemet jag använder för att matcha lediga platser så att det finns nära till 
eldplats osv.

Det kanske även skulle vara lämpligt att lägga allt i en RubyCamping-modul, men
eftersom jag redan har för många nivåer av intendering strundar jag i det.

Felhantering:
Jag har implementerat felhantering i Input-klassen. Användaren får ett nytt
försök att mata in datan om den bedöms vara inkorrekt. Jag har försökt göra
felmeddelandena så tydliga som möjligt.

Nummer matchas mot /^\d+$/ för att unvika negativa nummer osv.

Telefonnummer krävs på ett visst format med bindestreck, men egentligen kanske
man borde ha mer kontroll som t.e.x längd. Jag antar att det kan bli problem
om man vill ha utländska gäster. 

Strängar som namn, adress etc kan vara tomma. Kanske är det någon gäst som inte
vill uppge sin adress (vill man ha sådana gäster?).

Datum matchas först mot regexp:et /^\d{4}\-\d{2}\-\d{2}$/ för att se till att 
de inte skrivs in på något annat format. Datumet parsas sedan av Ruby:s inbyggda
Date-klass, så programmet kontrollerar om det verkligen är ett gilltigt datum.
(Skottår osv.)

Klasser Översikt:
RubyCamping är huvudklassen som äger samligen av Rentables och gäster (GuestList). Referenser
till dessa skickas med till MainMenu som har hand om inchecking och utchecknings alternativen
i menyn. MainMenu läser in gästtypen från användaren och tilldelas en Rentable där gästen
ska checkas in. Till skillnad från tidigare version är det nu Rentable-subklassen som har
hand om incheckning av gästen (i check_in). RubyCamping äger också prislistan och Economy-instansen.

Gäst-klassen har som tidigare hand om en gäst i systemet. Den har också referens till 
ekonomi-objektet och prislistan. Observera dock att när en gäst checkas in, kopieras
prislistan så alla gäster får en referens till en egen PriceList. Detta för att gästerna 
bara ska få betala det priset som var aktuellt när de chekade in.

PlotGuest är en subklass av Guest. Den överladdar Guest#check_in och ser till att
användaren frågas om gästen vill ha el eller inte. Den ser också till elmätarställningen
skrivs ut i listan och vid utcheckning.

CabinGuest är också en subklass av Guest. Den överladdar Guest#check_in och ger användaren
val av prisplan innan den anropar superklassens check_in.

Plot representar fortfarande en tomtplats. Den ärver från Rentable och överladdar 
Rentable#id och Rentable#calc_price som räknar ut priset inklusive el-förbrukningen.

Cabin representerar en stuga. Den ärver från Rentable. Den överladdar Rentable#id för
att få stugans namn i listningarna. Cabin#calc_price räknar ut priset och tar hänsyn
till vilken prisplan användaren har valt för gästen.

PriceList är en samling av PriceListEntry. Den ansvarar för prislistan samt har en 
funktion för deep copy.

Economy är en samling av EconomyPost:s. Klassen skriver ut ekonomirapporten och håller
reda på ekonomiposter i systemet. Det finns två subklasser till EconomyPost i systemet:
RentEconomyPost och ElectricityEconomyPost. Som båda representerar en "bokföringspost".

MainMenu, ListMenu, och EconomyMenu ärver från Menu. De ansvarar för varsin meny. MainMenu
anropas från RubyCamping. ListMenu och EconomyMenu aktiveras när användaren väljer 
respektive undermeny i MainMenu.

Input-klassen innehåller hjälpfunktioner för inmatning.

Nya klasser: 

Rentable - Representerar saker vi hyr ut.
    calc_price - räknar ut priset för vistelsen
    id - en sträng som representerar detta objekt i listorna
    can_occupy? - kan en gäst av denna typ bo i denna Rentable
    assign - statisk metod som tilldelar Rentable 

    @guest - referens till gästen som bor i denna Rentable

Cabin - Klass för stugor. Ärver från Rentable.
    id - skickar tillbaka stugans namn
    calc_price - tar hänsyn till prisplan 
    check_in - checkar in en gäst i denna stuga

PlotGuest - Klass för gäster som bor på tomtplats. Innehåller logik för el vid utchecking och incheckning.
    wants_electricity? - Använder gästen el?
    check_in - frågar användaren om gästen vill ha el 
    do_check_out - Callback från superklassen 
    check_out - Ser till att elmätaren återställs efter gästen har checkat ut 
    print_long - Ser till att mätarställning skriv ut om gästen använder el
    
    @electricity - Referens till Electricity-instansen för denna gäst
    @b_electricity - El?

CabinGuest - Klass för gäster som bor i stuga. Innehåller logik för val av prisplan vid incheckning.
    check_in  - frågar användaren vilken prisplan gästen vill ha
    @payment_plan - prisplanen

GuestList - Samling som håller reda på samtliga gäster som varit incheckade på Ruby Camping. Var tidigare en Array.
    add - lägger till gästen i adresslistan 

Economy -  Samling av EconomyPost:s. Håller reda på intäkterna och kan summera och reportera dem.
    report_summary - skriver ut ekonomisummeringen
    print_all_posts - skriver ut alla poster i Economy-instansen

EconomyPost - Dataobjekt i Economy
    report - skickar tillbaka datan i posten till report_summary 

RentEconomyPost - Representerar en post med hyrintäkt. Ärver från EconomyPost.
ElectricityEconomyPost - Representerar en post med intäkt från el. Ärver från EconomyPost.

ListMenu - Subklass till Menu som har hand om listmenyn
    list_all_guests - skriver ut alla gäster
    list_current_guests - skriver ut alla Rentables som antigen är LEDIGA eller har en gäst som bor där

EconomyMenu - Subklass till Menu som har hand om ekonomimenyn
    show_pricelist - visar prislistan
    edit_pricelist - menyn som låter dig redigera prislistan
    report_revenue - skriver ut ekonomisummeringen
    show_economy_posts - skriver ut alla poster 

MainMenu - Subklass till Menu som har hand om huvudmenyn
    check_in - hjälpfunktion till checking_in 
    checking_in - tar hand om incheckning
    checking_out - tar hand om utcheckning
    sub_menu - hjälpfunktion som startar undermenyer

Klasser Förändringar:
* Logiken för elmätaren har flyttats från Guest till PlotGuest. 
* Menyerna har flyttats från RubyCampings konstruktor till sina egna klasser
* Electricity har istället för bara ett mätarvärde två stycken: @before and @after och en reset funktion för att skifta dessa. Den har också en calc_price för att räkna ut elkostnaden.
* Input-metoderna har anpassats för att hantera avbrytna inmatningar
* Menu fångar inte längre NoMethodError utan kollar istället efter nil 
* Plot har utökats med check_in och calc_price
* main.rb är densamma!

