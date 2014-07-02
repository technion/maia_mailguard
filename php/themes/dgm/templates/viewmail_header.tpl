<table border="0" cellspacing="0" cellpadding="2" width="100%">
{if $from}
<tr><td class="mailheader" align="left" valign="top">
<font color="red">FROM:</font></td>
<td class="mailheader" align="left" valign="top">{$from}</td></tr>
{/if}
{if $to}
<tr><td class="mailheader" align="left" valign="top">
<font color="red">TO:</font></td>
<td class="mailheader" align="left" valign="top">{$to}</td></tr>
{/if}
{if $subject}
<tr><td class="mailheader" align="left" valign="top">
<font color="red">SUBJECT:</font></td>
<td class="mailheader" align="left" valign="top">{$subject}</td></tr>"
{/if}
<tr><td class="mailheader" align="left" valign="top" width="150">
<font color="red">CONTENT-TYPE:</font></td>
<td class="mailheader" align="left" valign="top">{$ctype}</td></tr>
<tr><td>&nbsp;</td></tr>
</table>