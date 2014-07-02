To: [% recipient %]
From: Maia Admin <[% admin_email %]>
Reply-To: Maia Admin <[% admin_email %]>
[% USE formatteddate = date %]Date: [% formatteddate.format %]
Subject: Maia Quarantine Digest
MIME-Version: 1.0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><body>
<div align="center">
<a href="[% baseurl %]/confirm.php?id=[% maia_user_id %]&euid=[% euid %]&ts=[% date | uri %]&token=[% confirm_token %]&manage=true">[Log in]</a> to manage your Maia account</a>
</div>
<div>Maia Mailguard made the following decisions regarding you email. If it made a mistake, you may report any email that was presumed good, but was actually spam, and release any that were quarantined incorrectly by clicking the corresponding link.</div>
[% FOREACH r IN list %]
[% FOREACH l IN r %] 
[% FOREACH l.value %]
[% IF loop.first %]
<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="100%">
<tr>
<td bgcolor="#cccccc" align="center" colspan="5"><font size="5"><b>[% titles.${l.key} %]</b></font></td>
</tr>
<tr>
<th bgcolor="#cccccc">Action</th>
<th bgcolor="#cccccc">Received</th>
<th bgcolor="#cccccc">From</th>
<th bgcolor="#cccccc">Subject</th>
[% IF l.key == 'spam' || l.key == 'ham' %]
<th bgcolor="#cccccc">Score</th>
[% END %]
</tr>
[% END %]
<tr>
<td bgcolor="#ffffff" align="center">
<a href="[% baseurl %]/rescue.php?id=[% maia_user_id %]&euid=[% euid %]&token=[% token %]&user_token=[% confirm_token %]&type=[% l.key %]">[% IF l.key == 'ham' %]Report[% ELSE %]Release[% END %]</a><br>
<a href="[% baseurl %]/rescue.php?id=[% maia_user_id %]&euid=[% euid %]&token=[% token %]&user_token=[% confirm_token %]&type=[% l.key %]&wblist=true">[% IF l.key == 'ham' %]Blacklist[% ELSE %]Whitelist[% END %]</a>
</td>
<td bgcolor="#ffffff">[% received_date %]</td>
<td bgcolor="#ffffff">[% sender %]</td>
<td bgcolor="#ffffff"><a href="[% baseurl %]/viewer.php?id=[% maia_user_id %]&euid=[% euid %]&token=[% token %]&user_token=[% confirm_token %]&cache_type=[% l.key %]&mail_id=[% mail_id %]">[% subject %]</a></td>
[% IF l.key == 'spam' || l.key == 'ham' %]
<td bgcolor="#ffffff">[% score %]</td>
[% END %]
</tr>
[% IF loop.last %]
</table></div><p>&nbsp;</p>
[% END %]
[% END %]
[% END %]
[% IF loop.last %]
<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="100%">
<tr>
<td bgcolor="#cccccc" align="center">
<a href="[% baseurl %]/confirm.php?id=[% maia_user_id %]&euid=[% euid %]&ts=[% date | uri %]&token=[% confirm_token %][% report_types %]">[Confirm All Remaining Items]</a>
</td>
</tr>
</table></div>
[% END %]
[% END %]
</body></html>

