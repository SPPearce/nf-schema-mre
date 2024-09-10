include { samplesheetToList } from 'plugin/nf-schema'

workflow {

    MAKECSVS()

    MAKECSVS.out.one
    .flatMap {one -> samplesheetToList(one, "schema_one.json") }
    .view{one -> "one: $one"}
    .set { ch_one }

    MAKECSVS.out.two
    .flatMap {it -> samplesheetToList(it, "schema_two.json") }
    .view{it -> "two: $it"}
    .set { ch_two }

}

process MAKECSVS {
  memory = '1.G'
  cpus = 1

  input:

  output:
  path('one.csv'), emit: one
  path('two.csv'), emit: two

  script:
  """
  echo "id,foo,bar,string,num" > one.csv
  echo "A,a,1,string1,3" >> one.csv
  echo "B,a,2,string2,3" >> one.csv
  echo "C,a,3,string1,3" >> one.csv
  echo "D,b,4,string2,2" >> one.csv
  echo "E,b,5,string1,2" >> one.csv
  echo "F,c,6,string2,2" >> one.csv

  echo "foo,path"   > two.csv
  echo "a,https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/generic/csv/test.csv" >> two.csv
  echo "b,https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/generic/tsv/expression.tsv" >> two.csv  
  echo "c,https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/generic/tsv/network.tsv" >> two.csv  
  """
}