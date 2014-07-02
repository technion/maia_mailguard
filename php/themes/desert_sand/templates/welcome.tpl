{include file="html_head.tpl"}
<div id="rightpanel">
   {include file="welcome/_protection.tpl"}
   <div id="welcome"><h2>{$lang.text_welcome_greeting}</h2>
    {if $firsttime}
    {$lang.text_welcome_first_time}
    {/if}
    {$lang.text_welcome_intro}
   </div>
 </div>
<div id="maincontent">
{if $message}
<div id="messagebox" align="center">
{$message}
</div>
{/if}

 {include file="welcome/_quickview.tpl"}
 {include file="welcome/_stats.tpl"}

 
  </div>
 {include file="html_foot.tpl"}
