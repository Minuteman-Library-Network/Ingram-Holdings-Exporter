/*
Jeremy Goldstein
Minuteman Library Network

Gathers bib records with a given location's holdings for use with Ingram's iPage feature
*/

DROP TABLE IF EXISTS som_bibs;

CREATE TEMP TABLE som_bibs AS

SELECT
l.bib_record_id

FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id  AND i.location_code ~ '^so'
LEFT JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'v'

GROUP BY 1
--Exclude multi-volume records due to liklihood of false positive holding matching in iPage
HAVING
COUNT(i.id) FILTER(WHERE v.field_content IS NOT NULL) = 0
;

DROP TABLE IF EXISTS isbn;

CREATE TEMP TABLE isbn AS

SELECT
s.record_id,
COALESCE(STRING_AGG(DISTINCT SUBSTRING(s.content FROM '^\d{9,12}[\d|X]'),'|'),'') AS "isbns"
FROM
som_bibs b
JOIN
sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
GROUP BY 1
;

SELECT
i.record_id,
COALESCE(SUBSTRING(o.content FROM '[0-9]+'),'') AS "001",
i.isbns AS "020"--,
--Uncomment if including 024 fields
--COALESCE(STRING_AGG(DISTINCT SUBSTRING(s3.content FROM '^\d+'),'|'),'') AS "024"

FROM
isbn i
JOIN
sierra_view.bib_record_property b
ON
--Limited to print formats in this example
i.record_id = b.bib_record_id AND b.material_code IN ('2','9','a','e','o','p','t')
LEFT JOIN
sierra_view.subfield o
ON
i.record_id = o.record_id AND o.marc_tag = '001'
--Uncomment if including 024 fields
/*LEFT JOIN
sierra_view.subfield s3
ON
bi.bib_record_id = s3.record_id AND s3.marc_tag = '024' AND s3.tag = 'a'

WHERE 
s3.content IS NOT NULL*/
