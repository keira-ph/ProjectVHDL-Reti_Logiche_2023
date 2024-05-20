# ProjectVHDL-Reti_Logiche_2023
## Prova Finale (Progetto di Reti Logiche) - A.A. 2022/2023
La specifica della *Prova Finale (Progetto di Reti Logiche)* per l’Anno Accademico 2022/2023 chiede di implementare un *modulo HW* (descritto in VHDL) che si interfacci con una memoria e che rispetti le indicazioni riportate nella seguente specifica.

### Descrizione del Sistema
Ad elevato livello di astrazione, il sistema:

Riceve indicazioni circa una *locazione di memoria*, il cui contenuto deve essere indirizzato verso un *canale di uscita* fra i quattro disponibili.
Le indicazioni circa il *canale da utilizzare* e *l’indirizzo di memoria* a cui accedere vengono forniti mediante un *ingresso seriale da un bit*.
Le *uscite del sistema*, ovvero i succitati canali, forniscono tutti i bit della parola di memoria in *parallelo*.
