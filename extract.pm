#======================================================================
#  author | Lucien Ledune
#    date | 2018-16-06
#======================================================================
# Module incluant des fonctions utilisées pour récupérer des 
# informations sur les lyrics d'une musique et les extraire 
# du site web https://www.azlyrics.com/
#======================================================================


package extract;

use strict;
use utf8;
use LWP::Simple;

#create an url from the title parameters
#parameters : group, song
sub convertURL {
	my $group = lc($_[0]);
	my $song = lc($_[1]);
	
	$group =~ s/[\W_]//g;
	$song =~ s/[\W_]//g;

	my $linkurl = "https://www.azlyrics.com/lyrics/$group/$song.html";
	return $linkurl;
}

#get song lyrics
#parameters : group, song
sub getSongLyrics {
	my $band = $_[0];
	my $song = $_[1];
	my $URL = convertURL($band, $song);
	#Get the html code into page
	my $page = get($URL) or die("URL wasn't found, maybe there is a typo in your song name/band ?");

	#Split it in lines into a tab
	my @lignes = split( /[\r\n]+/, $page );

	#Used to store the lyrics part only.
	my @lyrics;

	#trigger variable
	my $trigger = 0;
	#trigger used to get the first trigger back to 0 
	my $antiTrigger = 0; #They are used to start getting html lines when lyrics start, and stop when we're done. 
	
	
	
	

	#Checks for each line, starts getting the lines when lyrics start and stop when we reached the end of lyrics.
	for my $line (@lignes){
		if(lc($line) eq lc("<b>\"$song\"</b><br>") ){
			$trigger = 1;
		}elsif($antiTrigger == 1){
			$trigger = 0;
		}
		
		if($trigger == 1){
			push(@lyrics, $line);
		}
		
		if($trigger == 1){
			if($line eq "</div>"){
				$antiTrigger = 1;
			}
		}
		
	}



	#shift first lines since we already havbe title so we only have lyrics left. 
	for(my $i = 0; $i < 4; $i++){
		shift(@lyrics)
	}
	pop(@lyrics); #pop </div>

	#Print test to check if we successfully extract lyrics only.
	#for my $line2 (@lyrics){
		#print "$line2\n";
	#}
	return join("\n", @lyrics);
}


1;