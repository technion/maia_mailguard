<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
<link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
<link rel="stylesheet" href="libs/jquery/thickbox.css" type="text/css" media="screen">
<link rel="stylesheet" href="libs/jquery/ui.slider.extras.css" type="text/css" media="screen">
<link rel="stylesheet" href="{$template_dir}/css/jquery-ui-1.7.1.custom.css" type="text/css" media="screen">
<script type="text/javascript" src="tooltips.js"></script>
<script type="text/javascript" src="libs/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="libs/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="libs/jquery/selectToUISlider.jQuery.js"></script>
<script type="text/javascript" src="libs/jquery/thickbox.js"></script>
<script type="text/javascript" src="libs/jquery/jquery.dimensions.js"></script>
<script type="text/javascript" src="libs/jquery/jquery.bgiframe.js"></script>
<script type="text/javascript" src="libs/jquery/jquery.hoverIntent.js"></script>
<script type="text/javascript" src="libs/jquery/simpletip.js"></script>
<script type="text/javascript" src="{$template_dir}/javascript/desert_sand.js"></script>

{literal}
<!--[if lte IE 6]>

<script type="text/javascript">
function correctPNG() // correctly handle PNG transparency in Win IE 5.5 or higher.
   {
   for(var i=0; i<document.images.length; i++)
      {
	  var img = document.images[i]
	  var imgName = img.src.toUpperCase()
	  if (imgName.substring(imgName.length-3, imgName.length) == "PNG")
	     {
		 var imgID = (img.id) ? "id='" + img.id + "' " : ""
		 var imgClass = (img.className) ? "class='" + img.className + "' " : ""
		 var imgTitle = (img.title) ? "title='" + img.title + "' " : "title='" + img.alt + "' "
		 var imgStyle = "display:inline-block;" + img.style.cssText 
		 if (img.align == "left") imgStyle = "float:left;" + imgStyle
		 if (img.align == "right") imgStyle = "float:right;" + imgStyle
		 if (img.parentElement.href) imgStyle = "cursor:hand;" + imgStyle		
		 var strNewHTML = "<span " + imgID + imgClass + imgTitle
		 + " style=\"" + "width:" + img.width + "px; height:" + img.height + "px;" + imgStyle + ";"
	     + "filter:progid:DXImageTransform.Microsoft.AlphaImageLoader"
		 + "(src=\'" + img.src + "\', sizingMethod='scale');\"></span>" 
		 img.outerHTML = strNewHTML
		 i = i-1
	     }
      }
   }
window.attachEvent("onload", correctPNG);
</script>
<![endif]-->
{/literal}
</head>
<body>
<div id="tooltip" style="position:absolute;visibility:hidden"></div>

<div id="container">
  <div id="menu" class="topbanner4">
      {include file="menu.tpl"}
  </div>
  <div id="content"> 