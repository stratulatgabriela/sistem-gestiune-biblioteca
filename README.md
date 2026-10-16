Sistem de Gestiune Bibliotecă
Descriere generală

Aplicația Sistem de Gestiune Bibliotecă este dezvoltată în Retool, cu backend în Supabase (PostgreSQL), și are ca scop gestionarea digitală a unei biblioteci: cărți, utilizatori, rezervări, favorite și feedback.

Aplicația permite:

vizualizarea cărților disponibile

consultarea autorilor

rezervarea cărților

adăugarea cărților la favorite

gestionarea rezervărilor proprii

trimiterea de feedback

gestionarea contului de utilizator

Aplicația include:

pagină de Login

pagină de Register

Dashboard principal (DashboardCititor)

pagină separată pentru Feedback

Tehnologii utilizate

Frontend / UI: Retool

Backend / Bază de date: Supabase

SGBD: PostgreSQL (SQL standard)

Workflow-uri: Retool Workflows

Structura bazei de date (Supabase – PostgreSQL)
Tabel: Utilizatori
Coloană Tip Detalii
id uuid PK, gen_random_uuid()
nume text NOT NULL
email text UNIQUE, NOT NULL
telefon text opțional
data_inregistrare timestamp default
rol text NOT NULL, CHECK (admin, cititor)

Constrângeri & optimizări:

Primary Key pe id

UNIQUE + NOT NULL pe email

CHECK pe rol

Index implicit pe email (prin UNIQUE)

Tabel: Carti
Coloană Tip Detalii
id uuid PK
titlu text NOT NULL
autor text NOT NULL
an_publicare integer CHECK (an valid)
gen text NOT NULL
disponibila boolean default true

Constrângeri & indecși:

PK pe id

NOT NULL pe câmpurile esențiale

CHECK pe an_publicare

Index pe titlu

Index pe autor

Tabel: rezervari
Coloană Tip Detalii
id uuid PK
id_carte uuid FK → Carti(id)
id_cititor uuid FK → Utilizatori(id)
data_rezervare timestamp default now()
status text CHECK (Rezervată / Expirată)

Constrângeri & optimizări:

PK pe id

FK către Carti și Utilizatori

CHECK pe status

Index pe id_cititor

Index pe id_carte

Tabel: favorite
Coloană Tip Detalii
id uuid PK
id_carte uuid FK
id_cititor uuid FK
Tabel: Feedback
Coloană Tip Detalii
id uuid PK
user_id uuid FK
mesaj text NOT NULL
data timestamp default now()
Interogări SQL utilizate
Listare cărți
SELECT * FROM "Carti";

Rezervare carte
INSERT INTO rezervari (id_carte, id_cititor, status)
VALUES ({{ currentSourceRow.id }}, {{ current_user.id }}, 'Rezervată');

Vizualizare rezervările mele
SELECT r.id, c.titlu, c.autor, r.data_rezervare, r.status
FROM rezervari r
JOIN "Carti" c ON r.id_carte = c.id
WHERE r.id_cititor = {{ current_user.id }}
ORDER BY r.data_rezervare DESC;

Insert feedback
INSERT INTO Feedback (user_id, mesaj)
VALUES ({{ current_user.id }}, {{ feedback_text.value }});

Funcționalități implementate
Login & Register

Sistem de autentificare simplificat (fake login)

Salvarea utilizatorului logat în state global

Rolul utilizatorului este stocat și folosit pentru permisiuni

Roluri de utilizator

Admin – acces la funcționalități administrative

Cititor – acces la rezervări, favorite, feedback

Afișarea anumitor componente este condiționată de rolul utilizatorului.

Dashboard principal (DashboardCititor)

Conține tab-uri organizate astfel:

Cărți – listare + rezervare + favorite

Autori – vizualizare autori

Rezervările mele – tabel generat din SQL

Favorite – afișare favorite utilizator

Contul meu – date cont + feedback + logout

Rezervare carte

Buton dedicat în tabelul de cărți

Transmiterea id_carte prin additionalScope

Inserare în tabelul rezervari

Favorite

Inserare în tabelul favorite

Tab separat cu favoritele utilizatorului

Feedback

Pagină separată

Formular cu textarea

Salvare feedback în Supabase

Notificare de succes

Resetarea câmpului după submit

Buton „Înapoi” către Dashboard

Rapoarte și vizualizare date

Tabele cu:

filtrare

sortare

refresh

export CSV/XLSX

Rapoarte:

rezervările utilizatorului

număr de favorite

rezervări expirate

Retool Workflows

Workflow pentru:

actualizarea rezervărilor expirate

generarea rapoartelor

Existența workflow-urilor este demonstrată în Retool

Navigare între pagini

Navigarea între pagini se face cu:

utils.openApp("2dcd82c2-b3e7-11f0-ad70-33ac8490cc09", {
pageName: "DashboardCititor"
});

UX & Creativitate

Domeniu realist (bibliotecă)

Date de test plauzibile (autori reali, cărți cunoscute)

UI coerent, organizat pe tab-uri

Interacțiuni clare pentru utilizator
