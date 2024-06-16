-- Query 1:
-- Write a query to get data having length of Rna structures more than 12 with
-- them being added after 2008

SELECT * 
	FROM rnacen.rna 
	where (len > 12) AND (Extract(year from "timestamp") > 2008) 
	limit 100

-- Query 2:
-- How many pre computed RNA are present that are still
-- active and got their last release update before 2022

SELECT count(*) AS "Total Count"
	from rnacen.rnc_rna_precomputed
	where is_active = true and EXTRACT (year from update_date) < 2022

-- 55930772

-- Query 3
-- How many total pre computed RNA records for snoRNA and tRNA
-- were recorded in 2011, 2016, 2014, and 2020

SELECT rna_type, COUNT(*) AS "Total PreComputed RNA"
FROM rnacen.rnc_rna_precomputed 
WHERE rna_type IN ('snoRNA', 'tRNA')
AND EXTRACT(year FROM update_date) IN (2011, 2016, 2014, 2020)
GROUP BY rna_type;



-- Query 4
-- Can you give me the names of all databases built
-- for RNA with minimum length other than 100, 200, 300, 400, and 15

SELECT display_name AS "Name"
	FROM rnacen.rnc_database
	WHERE min_length not in (100, 200, 300, 400, 15)
-- rna_precomputed

	
-- Query 5
-- Can you get complete 500 records of sequences for
-- 	active regions and name your column as myregions in
-- 	which you are getting the region name column value.
-- 	Then tell me what different chromosomes with exon_count
-- 	we have for regions including center, east and north
-- 	using the name you set for your column


SELECT 
	sr.region_name AS myregions, sr.chromosome, sr.exon_count
	FROM rnacen.rnc_sequence_regions sr 
	LEFT JOIN rnacen.rnc_rna_precomputed rp 
	ON sr.urs_taxid = rp.id
	WHERE rp.is_active = true AND sr.region_name in ("center", "east", "north")
	limit 100