# QuerySense Report
## Global Deforestation, 1990 to 2016

Analysis of deforestation around the world to raise awareness about this crucial environmental topic

> Analysis & report by Charles Odili

### How the data looks like
![ER disgram](query-sense-report-erd.png)

## Key Findings & Recommendations

> See [The Full Report](querysense-1990-2016-deforestation-report.pdf)

### Key Findings

1.  Between 1990 and 2016, the world lost 3.21% of its forest area, which is more than the size of Peru as of 2016
2.  Within this period, the exact same regions ranked at the top and bottom of forest area size. Latin America & Caribbean maintained the highest global forest area though it witnessed a drop of 5% (from 51% to 46%). Conversely, the Middle East & North Africa remained the region with the lowest global forest area, though it's forest area increased by 0.29% (from 1.78% to 2.07%)
3.  The only regions of the world that decreased in percent forest area from 1990 to 2016 were Latin America & Caribbean (dropped from 51.03 % to 46.16%) and Sub-Saharan Africa (30.67% to 28.79%). However, the drop in forest area in the two aforementioned regions was so large, the percent forest area of the world decreased over this period from 32.42% to 31.38%.
4.  The top two countries that increased in forest area are China and the U.S.
5.  Brazil, Indonesia and Myanmar are the top 3 countries with the highest amount of lost forest area
6.  Togo, Nigeria and Uganda are the top 3 countries with the highest % of lost forest area


### Recommendations

1.  The two regions with potentially the most impact on global forestation are Sub-Saharan Africa and Latin America & Caribbean. Focus more efforts here.
2.  Countries in the high impact regions to focus more efforts include Brazil, Nigeria, Tanzania, Togo, Uganda, Mauritania and Honduras
3.  Nigeria is the only country that ranks in the top 5 both in terms of absolute square kilometer decrease in forest as well as percent decrease in forest area from 1990 to 2016. Therefore, this country has a significant opportunity ahead to stop the decline and hopefully spearhead remedial efforts.
4.  It would be great to study what drove the forest increase in China, the U.S, Iceland and French Polynesia, to see how it can be applied to the high risk and high impact countries listed in (2)


### Appendix: SQL Queries Used
All the queries used for the analysis can be found in the [src folder](/src). 

They are:

1.  [src/part-0-prep.sql](src/part-0-prep.sql)
2.  [src/part-1-global-situation.sql](src/part-1-global-situation.sql)
3.  [src/part-2-regional-outlook.sql](src/part-2-regional-outlook.sql)
4.  [src/part-3-country-level-detail.sql](src/part-3-country-level-detail.sql)


