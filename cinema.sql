-- Réalisez  les  requêtes  SQL  suivantes  avec  HeidiSQL  ou  PhpMyAdmin  (rédigez  les  requêtes dans un fichier .sql afin de garder un historique de celles-ci) : entre parenthèses les champs servant de référence aux requêtes.

-- a. Informations d’un film (id_film) : titre, année, durée (au format HH:MM) et réalisateur 

SELECT 
	f.titre_film,
	f.annee_sortie_france,
	f.duree_film,
	f.id_realisateur
FROM film f
INNER JOIN realisateur re ON re.id_realisateur = f.id_realisateur

-- b. Liste des films dont la durée excède 2h15 classés par durée (du +long au +court)

SELECT *
FROM film f
WHERE TIME(f.duree_film) > '02:15:00'
ORDER BY f.duree_film DESC

-- c. Liste des films d’un réalisateur (en précisant l’année de sortie) 

SELECT
	f.id_film,
	f.titre_film,
	f.annee_sortie_france,
	f.id_realisateur 
FROM film f
INNER JOIN realisateur re ON re.id_realisateur = f.id_realisateur
WHERE re.id_realisateur = 1

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
	re.id_realisateur 
FROM 
	film f
INNER JOIN realisateur re ON re.id_realisateur = f.id_realisateur
GROUP BY
	re.id_realisateur 
ORDER BY 
	nbrFilm DESC

-- f.Casting d’un film en particulier (id_film) : nom, prénom des acteurs + sexe

SELECT
	f.id_film,
	f.titre_film,
	p.nom_personne,
	p.prenom_personne,
	p.sexe_personne
FROM
	casting c
INNER JOIN film f ON f.id_film = c.id_film
INNER JOIN acteur ac ON ac.id_acteur = c.id_acteur
INNER JOIN personne p ON p.id_personne = ac.id_personne
WHERE f.id_film = 1