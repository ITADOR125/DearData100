Table table;

void setup()
{
  size(1200,900);
  background(245, 243, 238);
  table = loadTable("data/observations.csv", "header");
  println("Loaded" + table.getRowCount()+"rows");
}
