2019-09-1
SELECT ME.NAME, M.YEAR, COUNT(*) AS CNT
FROM MovieExec ME
JOIN MOVIE M
ON ME.CERT# = M.PRODUUCERC#
GROUP BY ME.CERT#, ME.NAME, M.YEAR