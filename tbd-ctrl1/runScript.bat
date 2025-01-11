@echo off
psql -U postgres -f dbCreate.sql
psql -U postgres -d airlinedb -f loadData.sql
psql -U postgres -d airlinedb -f runStatements.sql
psql -U postgres -d airlinedb -f runStatements.sql > resultados_consultas.txt