use Try::Tiny;
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Slice;
use Bio::EnsEMBL::Utils::Slice;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org', # alternatively 'useastdb.ensembl.org'
    -user => 'anonymous',
    -port => 5306 ); #This is not constant. Sometimes it will be 3306.

my $gene_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Gene' ); #Change the organism names accordingly. 

open(FILE,"Raw_counts_filter.txt");

while ($line = <FILE>) {	
	chomp $line;
	@columns=split("\t",$line);
	@failed_ids="";
	try {
	my $gene = $gene_adaptor->fetch_by_stable_id(trim($columns[0]));
	my $start = $gene->seq_region_start();
	my $end = $gene->seq_region_end();
	my $length=$end-$start;
	print join("\t",@columns)."\t".$length."\n";
	} catch {
	push (@failed_ids, $columns[0]."\n");
	};
}

print @failed_ids;
