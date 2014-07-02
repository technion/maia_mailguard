{include file="html_head.tpl"}

{if $button == "add"}

        <div align="center">
        <table border="0" cellspacing="2" cellpadding="2">
        <tr><td align="center" class="messagebox">
        {if $new_email}

            {if ($super || !$bad_domain) && !$bad_user && $succeeded}
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
        <table border="0" cellspacing="2" cellpadding="2">
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
        <table border="0" cellspacing="2" cellpadding="2">
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
        <table border="0" cellspacing="2" cellpadding="2">
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
        {if $user}
        <div align="center">{capture assign="title"}{$lang.text_search_results}
          &nbsp;<font size="3"><a href="adminhelp.php#impersonate{$sid}" target="new">[?]</a></font>{/capture}
        {include file="settings/_userlist-table.tpl" user_header=$lang.text_user_found show_delete="0" title=$title}
        </div>
        {else}
            <div class="messagebox">
            {$lang.text_user_not_found}
            </div>
        {/if}
        <p>&nbsp;</p>
        <div align="center">
        <a href="adminusers.php{$sid}">{$lang.link_users_menu}</a>
        </div>
{/if}

{include file="html_foot.tpl"}
