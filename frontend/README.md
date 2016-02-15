# Suspicious

IT Threats GeoDashboard

## Frontend

### Architecture

Suspicious may be deployed within a web instance :

/var/www/suspicious.yourdomain.com/frontend (htdocs)

/var/www/suspicious.yourdomain.com/frontend/index.html (d3js)

/var/www/suspicious.yourdomain.com/frontend/img (ui ressources)

/var/www/suspicious.yourdomain.com/frontend/js (ui ressources)

/var/www/suspicious.yourdomain.com/frontend/geo (ui ressources)

/var/www/suspicious.yourdomain.com/frontend/db (timelined csv db)

### Frontend deployment

#### Everything on the same system

End users should not access the backend, this directory won't be a child directory
of your web root directory (htdocs). Backend and Frontend directory may stand in the
same directory while Frontend directory will be the root directory of your web instance.

#### Frontend/Backend Architecture

It would be possible to define an architecture with a frontend and a backend server :
  * if data duplication is not an issue for you, a simple RDIST (differential file sync
over ssh) would allow you to plan frontend update,
  * an NFS mount query from the backend server should allow to mount the frontend/db
directory with read/write access to enable backend processors to update the frontend.

### How to add fail2ban services to suspicious threat groups

There is a small peace of code you will have to maintain in the index.html
frontend file in order to associate fail2ban services to suspicious threat
groups : mail, telephony, email, web, recidive.

#### Threat groups

If you need to modify or adapt groups icons, groups name, update the
following var in frontend/index.html :

	var legendMap = [ { 'img/ssh-threat.png' : 'Authentication' },
			  { 'img/sip-threat.png' : 'Telephony' },
			  { 'img/mail-threat.png' : 'Email' },
			  { 'img/wordpress-threat.png' : 'Web' },
			  { 'img/hacker-threat.png' : 'Recidive' },
			  { 'img/unknown-threat.png' : 'Uncommented' }
			];

#### Threat loading from csv files

Then, when suspicious will load threat from csv files, we'll have to check
fail2ban service name (d.service) and return the right image to this threat.

The d.service var contain the fail2ban service name, you can use either :

	d.service == "<string>"

or

	d.service.include("<string>")

to make your check and then return the right threat group image to end-user UI :

	return('img/service-threat.png')

Here is the native peace of code included in your index.html you'll have to update :

	.attr("xlink:href", function(d) {
                     if (d.service.includes('recidive')||d.occurences>=10) { return('img/hacker-threat.png'); }
                     else if (d.service == 'ssh') { return('img/ssh-threat.png'); }
                     else if (d.service.includes('cgpro-sip')) { return('img/sip-threat.png'); }
                     else if (d.service.includes('cgpro-smtp')) { return('img/mail-threat.png'); }
                     else if (d.service.includes('-wp')) { return('img/wordpress-threat.png'); }
                     else { return('img/unknown-threat.png'); }
                   })

