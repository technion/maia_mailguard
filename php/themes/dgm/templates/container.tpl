<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>
{$banner_title}: {$lang.banner_subtitle}
</title>
<meta name="author" content="Robert LeBlanc">
<meta name="copyright" content="Copyright 2004 Robert LeBlanc, All Rights Reserved">
<meta name="description" content="Maia Mailguard, a spam and virus management system for mail servers">
<meta name="keywords" lang="en" content="maia,amavis,virus,spam,spamassassin,mail">
<meta http-equiv="Content-Type" content="text/html; charset={$html_charset}">
<meta http-equiv="Refresh" content="{$session_timeout}; url=logout.php">
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/style.css">
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/layout.css">
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/color.css">
{$page_css}
<link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
{$page_javascript}
<script type="text/javascript" language="JavaScript" src="libs/pngfix.js"></script>
{include file="menu.tpl" assign="menu"}
{include file="quickstats.tpl" assign="headerrightcontent"}
</head>
<body>
<div class="wrapper">
<div class="header">
<div class="headerleft">{include file="header.tpl"}</div>
<div class="headerright">{$headerrightcontent}</div>
<div class="headercenter">{$headercontent}</div>
<div style="clear: both;">&nbsp;</div>
</div>
{if $rightcontent != ""}
<div id="right">{$rightcontent}</div>
<div id="leftmiddle">
  <div id="center">{$maincontent}</div>
  <div id="left">{$menu}</div>
</div>
{else}
<div id="center">{$maincontent}</div>
<div id="left">{$menu}</div>
{/if}


<div class="clear">&nbsp;</div>
<div id="footer"><p>Vist the Maia Mailguard website at <a href="http://www.maiamailguard.com">http://www.maiamailguard.com</a><br>
Development issues and trouble tickets can be registered at:  <a href="https://www.maiamailguard.com/cgi-bin/trac.cgi">https://www.maiamailguard.com/cgi-bin/trac.cgi</a><br>


&copy; 2004 Robert LeBlanc and David Morton.</div>

</div>
</body>
</html>
