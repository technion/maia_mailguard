{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

    <div id="welcome"><h1>{$lang.text_welcome_greeting}</h1></div>
    
 <div id="quickview_wrapper">
    {* here comes the quick view of cache contents *}
    <div class="quickview">
        <form method="post" action="welcome.php{$sid}" name="cache">
        <input type="hidden" name="maxitemid" value="{$maxitemid}">
        <table width="100%" border="0" cellspacing="2" cellpadding="2">
        <tr>
            <td class="menubanner" align="center" colspan="2">{$lang.header_cache_contents}</td>
        </tr>
        <tr>
            <td class="suspectedham" align="center">
            <a href="list-cache.php{$msid}cache_type=ham">{if $use_icons}<img src="{$template_dir}images/ham.png" border="0" alt=""><br>{/if}[{$lang.action_ham_cache}]</a>
            </td>
            <td class="suspectedham" >
            {$hamtext}
            </td>
        </tr>
        <tr>
            <td class="suspectedspam" align="center">
            <a href="list-cache.php{$msid}cache_type=spam">{if $use_icons}<img src="{$template_dir}images/spam.png" border="0" alt=""><br>{/if}[{$lang.action_spam_cache}]</a>
            </td>
            <td class="suspectedspam" >
            {$spamtext}
            </td>
        </tr>
        <tr>
            <td class="suspectedvirus" align="center">
            <a href="list-cache.php{$msid}cache_type=virus">{if $use_icons}<img src="{$template_dir}images/virus.png" border="0" alt=""><br>{/if}[{$lang.action_virus_cache}]</a>
            </td>
            <td class="suspectedvirus" >
            {$virustext}
            </td>
        </tr>
        <tr>
            <td class="badattachment" align="center">
            <a href="list-cache.php{$msid}cache_type=attachment">{if $use_icons}<img src="{$template_dir}images/banned-file.png" border="0" alt=""><br>{/if}[{$lang.action_banned_cache}]</a>
            </td>
            <td class="badattachment">
            {$bannedtext}
            </td>
        </tr>
        <tr>
            <td class="badheader" align="center">
            <a href="list-cache.php{$msid}cache_type=header">{if $use_icons}<img src="{$template_dir}images/bad-header.png" border="0" alt=""><br>{/if}[{$lang.action_header_cache}]</a>
            </td>
            <td class="badheader">
            {$headertext}
            </td>
        </tr>
        <tr>
            <td class="menuheader" align="center" colspan=2>
            <input type="submit" name="delete_all_items" value="{$lang.button_delete_all_items}">
            </td>
        </tr>
        </table>
        </form>
    </div>
{*
    <div id="">
        <table align="center" class="panel1 outy">
        <tr>
            <td class="suspected_spambody inny"><b>{$spam_for_user}</b> {$lang.text_welcome_spam_blocked}</td>
            <td class="virusbody inny"><b>{$virus_for_user}</b> {$lang.text_welcome_virus_blocked}</td>
        </tr>
        <tr>
            <td class="suspected_spambody inny"><b>{$spam_for_system}</b> {$lang.text_welcome_spam_blocked_system}</td>
            <td class="virusbody inny"><b>{$virus_for_system}</b> {$lang.text_welcome_virus_blocked_system}</td>
        </tr>
        </table>
    </div>*}
</div><!-- end col2 -->

{/capture}
{capture assign="rightcontent"}

    {if $firsttime}
{$lang.text_welcome_first_time}
{/if}
<div class="intro">
    {$lang.text_welcome_intro}
</div>
{/capture}
{capture assign="headercontent"}
    <div id="protectioncontrol">
        <form method="post" name="protectionlevel" action="welcome.php{$sid}">
       
        <div>{$lang.text_welcome_current_level}
        <br><h2>{$lang.radio_protection.$protection}</h2>
        </div>
        <span id="protectionwidget"> 
                <img src="{$template_dir}images/lowprotection.png" border="0" alt="">
                <input type="radio" name="protection_level" value="off" {if $protection == "off"}checked{/if}>{$lang.radio_protection.off}
                <input type="radio" name="protection_level" value="low" {if $protection == "low"}checked{/if}>{$lang.radio_protection.low}
                <input type="radio" name="protection_level" value="medium" {if $protection == "medium"}checked{/if}>{$lang.radio_protection.medium}
                <input type="radio" name="protection_level" value="high" {if $protection == "high"}checked{/if}>{$lang.radio_protection.high}
                <img src="{$template_dir}images/highprotection.png" border="0" alt="">
          <br>
          </span>
        {if $protection == "custom"}
        {$lang.text_welcome_custom_level}
        {/if}   
        <input  class="protectionbump" type="submit" name="change_protection" value="{$lang.button_change_protection}">
   
        </form>
    </div>
{/capture}

{capture assign="page_css"}
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/welcome.css">
{/capture}

{assign var="page_javascript" value=""}
{include file="container.tpl"}
