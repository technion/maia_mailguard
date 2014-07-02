{include file="html_head.tpl"}

<h3 align="center">
<?php print(strftime("As of %Y-%m-%d %H:%M:%S %Z")); ?>
</h3>

<?php display_stats_summary(0, true, "", "?"); ?>

<p>&nbsp;</p>

<div align="center">
<a href="http://www.renaissoft.com/maia/"><img src="images/poweredbymaia.gif" border="0" alt="Powered by Maia Mailguard"></a>
</div>

{include file="html_foot.tpl"}
