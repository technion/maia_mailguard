{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

{if $button == "add"}

        <div align="center">
        <table border="0" cellspacing="2" cellpadding="2" class="panel1 outy">
        <tr><td align="center" class="messagebox">
        {if $new_email}

            {if ($super || !$bad_domain) && !$bad_user}
                {$lang.text_address_added}
            {else}
                {$lang.text_address_not_added}
            {/if}

        {else}
            {$lang.text_address_not_added}
        {/if}
        </td></tr>
        </table></div>
        <p>&nbsp;</p>
        <div align="center">
        <a href="adminusers.php{$sid}">{$lang.link_users_menu}</a>
        </div>

{elseif $button == "delete_email"}

        <div align="center">
        <table border="0" cellspacing="2" cellpadding="2" class="panel1 outy">
        <tr><td align="center" class="messagebox">
        {if $delete_email}
            {if $delete_failed}
              {$lang.text_address_not_deleted}
            {else}
              {$lang.text_address_deleted}
            {/if}
        {else}
            {$lang.text_address_not_deleted}
        {/if}
        </td></tr>
        </table></div>
        <p>&nbsp;</p>
        <div align="center">
        <a href="adminusers.php{$sid}">{$lang.link_users_menu}</a>
        </div>

{elseif $button == "delete_user"}

        <div align="center">
        <table border="0" cellspacing="2" cellpadding="2" class="panel1 outy">
        <tr><td align="center" class="messagebox">
        {if $del_user}
            {$lang.text_user_deleted}
        {else}
            {$lang.text_user_not_deleted}
        {/if}
        </td></tr>
        </table></div>
        <p>&nbsp;</p>
        <div align="center">
        <a href="adminusers.php{$sid}">{$lang.link_users_menu}</a>
        </div>

{elseif $button == "link"}

        <div align="center">
        <table border="0" cellspacing="2" cellpadding="2" class="panel1 outy">
        {if $email && $user}
            {foreach from=$lang.text_address_linked_array item=text_address_linked}
                <tr><td align="center" class="messagebox">
                {$text_address_linked}
                </td></tr>
            {/foreach}
            </table></div>
            <p>&nbsp;</p>
        {else}
            <tr><td align="center" class="messagebox">
            {$lang.text_address_not_linked}
            </td></tr>
        {/if}
        </table></div>
        <p>&nbsp;</p>
        <div align="center">
        <a href="adminusers.php{$sid}">{$lang.link_users_menu}</a>
        </div>

{elseif $button == "find"}

        <div align="center">
        <table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">
        {if $lookup}
            {if $user}
              <tr><td class="panel3 outy" align="center">
              {$lang.text_user_found}
              &nbsp;<font size="3"><a href="adminhelp.php#impersonate{$sid}" target="new">[?]</a></font>
              </td>
                <td class="suspectedham">{$lang.ham_header}</td>
                <td class="suspectedspam">{$lang.spam_header}</td>
                <td class="suspectedvirus">{$lang.virus_header}</td>
                <td class="badattachment">{$lang.banned_header}</td>
                <td class="badheader">{$lang.badheader_header}</td></tr>
              {foreach from=$user key=key item=row}
                  <tr><td class="panel2" align="center">
                  <a href="ximpersonate.php{$msid}id={$row.id}">{$key}</a></td>
                    <td class="suspectedham">{$row.ham}</td>
                    <td class="suspectedspam">{$row.spam}</td>
                    <td class="suspectedvirus">{$row.virus}</td>
                    <td class="badattachment">{$row.file}</td>
                    <td class="badheader">{$row.header}</td></tr>
                {/foreach}

            {else}
                <tr><td align="center" class="messagebox">
                {$lang.text_user_not_found}
                </td></tr>
            {/if}
        {else}
            <tr><td align="center" class="messagebox">
            {$lang.text_user_not_found}
            </td></tr>
        {/if}
        </table></div>
        <p>&nbsp;</p>
        <div align="center">
        <a href="adminusers.php{$sid}">{$lang.link_users_menu}</a>
        </div>
{/if}

{/capture}
{include file="container.tpl"}
