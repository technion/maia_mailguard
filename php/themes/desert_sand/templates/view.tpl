{if ! $ajax}{include file="html_head.tpl"}{/if}
{if ! $error}
<script language="JavaScript"><!--
{if $ajax}
{literal}
function itemAction(action, rvalue) {
        $.ajax({
          type: "POST",
          {/literal}url: "view.php{$msid}mail_id={$id}&cache_type={$cache_type}"{literal},
          dataType: "script",
          {/literal}data: "ajax=true&cache_item[m][{$id}]=" + rvalue{literal} + "&ufid=" + document.viewmail.ufid.value
        });
}
{/literal}
{else}
{literal}
function itemAction(action, rvalue) {
        document.forms.viewmail["cache_item[m][{/literal}{$id}{literal}]"].value = rvalue;
        document.viewmail.submit(); 
    }
{/literal}
{/if}
{literal}
function wblistAction(email,type) {
     $.ajax({
        type: "POST",
        {/literal}url: "wblist.php{$msid}action="{literal} + type,
        dataType: "script",
        data: "ajax=true&newaddr=" + email + "&ufid=" + document.viewmail.ufid.value
      });
}
{/literal}
//--></script>
<div><div id="viewmessage"></div>
{form name="viewmail" action="#"}
<input type="hidden" name="cache_item[m][{$id}]" value="">

<div class="topbanner4">
{include file="viewmail_menu.tpl"}
</div>
<div id="spam_report">
{include file="display_spam_report.tpl"}
</div>
{if $headers}
{include file="view-headers.tpl"}
{/if}
{include file="view-smtp.tpl"}
<div id="message_detail">
{$message}
</div>
<div class="topbanner4">
{include file="viewmail_menu.tpl"}
</div>
</form>
</div>
<script type="text/javascript">
{literal}
$('.message').simpletip('.DisplayLink',{});
{/literal}
</script>
{else}

{* Error!  Mail doesn't belong to this user! *}
<div>
<table border="0" cellspacing="2" cellpadding="2">
<tr>
<td class="messagebox" align="center">
{$error}
</td>
</tr></table></div>
{/if}
{if ! $ajax}{include file="html_foot.tpl"}{/if}