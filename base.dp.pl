open FILE,"<$ARGV[0]"; 
my %hash;
while(defined($line=<FILE>)){
	chomp;
	@colu=split(/\t/,$line);
	$bi="$colu[0],$colu[1],$colu[2]";
	$hash{$bi}=1;
	$hash1{$bi}=$colu[3];	
}
close FILE;

open IN,"<$ARGV[1]";
while(defined($line=<IN>)){
	chomp;
	@colu=split(/\t/,$line);
	$bi="$colu[0],$colu[1],$colu[2]";
	if(exists $hash{$bi}){
		$baseinfo=$colu[4];
		$colu[4]=~s/\$|\<|\>|\^\S|\*//g;
		$colu[4]=~s/\.|\,/$colu[2]/g;	
		print "$colu[0]\t$colu[1]\t$colu[2]\t$hash1{$bi}\t";
		$colu[4]=~s/([0-9]+[ACGTNacgtn]+)||(atcgATCG)/$1\t/ig;
		@info=split(/\t/,$colu[4]);
		$a=0;$t=0;$c=0;$g=0;
		foreach(@info){
			if($_=~/\+(\d+)(.*)/||$_=~/\-(\d+)(.*)/){
				$sub = substr($2,$1);
				$sub=~s/([atcgATCG])/$1\t/ig;
				@subinfo=split(/\t/,$sub);
				foreach(@subinfo){
					if($_=~/a|A/){$a++;}
					if($_=~/t|T/){$t++;}
					if($_=~/c|C/){$c++;}
					if($_=~/g|G/){$g++;}
				}
			}else{
				if($_=~/a|A/){$a++;}
				if($_=~/t|T/){$t++;}
				if($_=~/c|C/){$c++;}
				if($_=~/g|G/){$g++;}
			}	
		}
		$dep=$a+$t+$c+$g;
		print "$dep\t$a\t$t\t$c\t$g\t$baseinfo\n";
	}
}
