-- Réalisez  les  requêtes  SQL  suivantes  avec  HeidiSQL  ou  PhpMyAdmin  (rédigez  les  requêtes dans un fichier .sql afin de garder un historique de celles-ci) : entre parenthèses les champs servant de référence aux requêtes.

-- a. Informations d’un film (id_film) : titre, année, durée (au format HH:MM) et réalisateur 

SELECT 
	f.titre,
	f.date_sortie_france,
	f.duree,
	f.id_realisateur
FROM film f
INNER JOIN realisateur re ON re.id_realisateur = f.id_realisateur

-- b. Liste des films dont la durée excède 2h15 classés par durée (du +long au +court)

CREATE VIEW dureeFilmHeure AS
SELECT
	f.id_film,
	f.titre,
SEC_TO_TIME(f.duree*60) AS tempsHeure
FROM film f

SELECT 
	id_film,
	titre,
	tempsHeure
FROM dureeFilmheure
WHERE tempsHeure > '02:15:00'
ORDER BY tempsHeure DESC

-- c. Liste des films d’un réalisateur (en précisant l’année de sortie) 

SELECT
	f.id_film,
	f.titre,
	f.date_sortie_france,
	f.id_realisateur 
FROM film f
INNER JOIN realisateur re ON re.id_realisateur = f.id_realisateur
WHERE re.id_realisateur = 1
ORDER BY f.date_sortie_france DESC

-- d. Nombre de films par genre (classés dans l’ordre décroissant)

SELECT 
	COUNT(f.id_film) AS nbrFilm,
	g.libelle 
FROM 
	appartenir ap
INNER JOIN film f ON f.id_film = ap.id_film
INNER JOIN genre g ON g.id_genre = ap.id_genre
GROUP BY
	g.libelle 
ORDER BY 
	nbrFilm DESC

-- e. Nombre de films par réalisateur (classés dans l’ordre décroissant)

SELECT 
	COUNT(f.id_film) AS nbrFilm,
	re.id_realisateur,
	pe.prenom,
	pe.nom 
FROM 
	film f
INNER JOIN realisateur re ON re.id_realisateur = f.id_realisateur
INNER JOIN personne pe ON pe.id_personne = re.id_personne
GROUP BY
	re.id_realisateur 
ORDER BY 
	nbrFilm DESC

-- f. Casting d’un film en particulier (id_film) : nom, prénom des acteurs + sexe

SELECT
	f.id_film,
	f.titre,
	p.prenom,
	p.nom,
	p.sexe
FROM
	casting c
INNER JOIN film f ON f.id_film = c.id_film
INNER JOIN acteur ac ON ac.id_acteur = c.id_acteur
INNER JOIN personne p ON p.id_personne = ac.id_personne
WHERE f.id_film = 1

-- g. Films tournés par un acteur en particulier (id_acteur) avec leur rôle et l’année de sortie (du film le plus récent au plus ancien)

SELECT
	f.id_film,
	f.titre,
	f.date_sortie_france,
	p.prenom,
	p.nom,
	ro.nom_role
FROM
	casting c
INNER JOIN film f ON f.id_film = c.id_film
INNER JOIN acteur ac ON ac.id_acteur = c.id_acteur
INNER JOIN role ro ON ro.id_role = c.id_role
INNER JOIN personne p ON p.id_personne = ac.id_personne
WHERE ac.id_acteur = 1
ORDER BY f.date_sortie_france DESC

-- h. Liste des personnes qui sont à la fois acteurs et réalisateurs

SELECT
	ac.id_acteur,
	re.id_realisateur,
	p.prenom,
	p.nom
FROM personne p
INNER JOIN acteur ac ON ac.id_personne = p.id_personne
INNER JOIN realisateur re ON re.id_personne = p.id_personne

-- i. Liste des films qui ont moins de 5 ans (classés du plus récent au plus ancien)

SELECT
	f.id_film,
	f.titre,
	YEAR(f.date_sortie_france) AS releaseYear,
	YEAR(NOW()) AS currentYear
FROM
	film f
GROUP BY
	f.id_film,
	f.titre
HAVING SUM(currentYear - releaseYear) < 5
ORDER BY f.id_film DESC

-- j. Nombre d’hommes et de femmes parmi les acteurs

SELECT
	COUNT(ac.id_acteur) AS nbrActeur,
	p.sexe
FROM 
	personne p
INNER JOIN acteur ac ON ac.id_personne = p.id_personne
GROUP BY p.sexe

-- k. Liste des acteurs ayant plus de 50 ans (âge révolu et non révolu)

SELECT
	ac.id_acteur,
	p.prenom,
	p.nom,
	YEAR(p.date_naissance) AS dateBirth,
	YEAR(NOW()) AS currentYear
FROM
	acteur ac
INNER JOIN personne p ON p.id_personne = ac.id_personne
GROUP BY
	ac.id_acteur,
	p.prenom,
	p.nom
HAVING SUM(currentYear - dateBirth) >= 50


-- l. Acteurs ayant joué dans 3 films ou plus

SELECT
	COUNT(f.id_film) AS nbrFilm,
	ac.id_acteur,
	p.prenom,
	p.nom
FROM
	acteur ac
INNER JOIN personne p ON p.id_personne = ac.id_personne
INNER JOIN casting c ON c.id_acteur = ac.id_acteur
INNER JOIN film f ON f.id_film = c.id_film
GROUP BY
	ac.id_acteur,
	p.prenom,
	p.nom
HAVING nbrFilm >= 3
