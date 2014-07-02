{if $message}
{capture assign="headercontent"}
  <div class="statusmessage"> 
         {$message} 
  </div>
{/capture}
{/if}

{capture assign="page_css"}
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/list_cache.css">
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/cache_buttons.css">
{/capture}


{capture assign="page_javascript""}
<script language="JavaScript" type="text/javascript" src="{$template_dir}/code/list-cache.js"></script>
{/capture}

{capture assign="maincontent"}
    <div class="cache-container"> <!-- cache table -->
      <form method="post" action="list-cache.php{$msid}cache_type={$cache_type}" name="cache">
            <input type="hidden" name="maxid" value="{$maxid}">
      {if ! $nothing_to_show}
       {include file="cache_pager.tpl"}
        {include file="list-cache-table.tpl"}
       {include file="cache_pager.tpl"}
	   </form>
  </div><!-- cache table -->
  {else}
    <div align="center">
   
    {$lang.text_empty}
    </div>
    {/if}
    
    <div>
    <a href="welcome.php{$msid}">[{$lang.link_welcome}]</a>
    </div>

{/capture}

{capture assign="rightcontent"}
<div class="panel2 outy">
<p>Some help text can go over here. It needs to be localized.</p>
<p>Maia needs your help to become better!  Help train Maia by telling it ''if it did the right thing!</p>
<p>
<img src="{$template_dir}images/sisadmin.png">Click this icon to "Report" the selected messages as SPAM<p>
<p><img src="{$template_dir}images/trashcan_empty.png">Click this icon to "Ignore" the selected messages.
This is usefull when the message may look spammy, but is not actually spam.</p>
<p><img src="{$template_dir}images/mail.png">Click this icon to confirm selected email as good "ham". If the message has been quarantined incorrectly, 
this will allow the message to be delivered to your email client.</p>
</div>
{/capture}

{capture assign="headercontent"}
{$message}
{/capture}

{capture assign="headerrightcontent"}
more text here
{/capture}
{include file="container.tpl"}
