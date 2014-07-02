{if $pages.total > 1}
<div align="center">
{$links}
</div>
{/if}
<div>
</div>
{include file="viewmail_menu.tpl" showraw=false}
<div class="cache_sort">
  <span class="cachecheck">&nbsp;&nbsp;<a id="checkcontrol" onclick="toggleCheckAll()">Select</a> all</span>
   {strip}<span class="cachesort">Sort by:
    <ul><li><a class="{if $sortby.column == "score"}inny{else}outy{/if} sortbutton panel2 c_score" 
   href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.score}">
   {$lang.text_score}
   {if $sortby.column == "score"}
     <img class="sortimage" src="{$template_dir}images/sort{if $sortby.score == "xd"}up{else}down{/if}.png">
   {/if}
    </a></li>
    <li><a class="{if $sortby.column == "subject"}inny{else}outy{/if} sortbutton panel2 c_subject" 
href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.subject}">
{$lang.text_subject}
 {if $sortby.column == "subject"}
     <img class="sortimage" src="{$template_dir}images/sort{if $sortby.subject == "sd"}up{else}down{/if}.png">
   {/if}
 </a></li>
<li><a class="{if $sortby.column == "received_date"}inny{else}outy{/if} sortbutton panel2 c_received" 
href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.date}">
{$lang.text_received}
   {if $sortby.column == "received_date"}
     <img class="sortimage" src="{$template_dir}images/sort{if $sortby.date == "dd"}up{else}down{/if}.png">
   {/if}</a></li>
<li><a class="{if $sortby.column == 'sender_email'}inny{else}outy{/if} sortbutton panel2 c_sender"  
href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.from}">
{$lang.text_from}
 {if $sortby.column == "sender_email"}
     <img class="sortimage" src="{$template_dir}images/sort{if $sortby.from == "fd"}up{else}down{/if}.png">
   {/if}
</a></li>
{*<li><a class="{if $sortby.column == "recipient_email"}inny{else}outy{/if} sortbutton panel2 c_recipient" 
href="list-cache.php{$msid}cache_type={$cache_type}&sort={$sortby.recipient_email}">
{$lang.text_to}
{if $sortby.column == "recipient_email"}
    <img class="sortimage" src="{$template_dir}images/sort{if $sortby.from == "td"}up{else}down{/if}.png">&nbsp;
</a></li>*}
</ul>
</span>{/strip}
</div>
