   <div id="quickview" class="ui-widget">
     <div class="ui-widget-header ui-corner-top"><h1>{$lang.header_cache_contents}</h1></div>
        {form action="welcome.php$sid" name="cache"}
        <input type="hidden" name="maxitemid" value="{$maxitemid}">
        <table>
        <tr>
            <td class="hambody" align="center">
            <a href="list-cache.php{$msid}cache_type=ham">{if $use_icons}<img src="{$template_dir}images/ham.png" border="0" alt="{$lang.action_ham_cache}"><br>{/if}[{$lang.action_ham_cache}]</a>
            </td>
            <td class="hambody" >
            {$hamtext}
            </td>
        </tr>
        <tr>
            <td class="suspected_spambody" align="center">
            <a href="list-cache.php{$msid}cache_type=spam">{if $use_icons}<img src="{$template_dir}images/spam.png" border="0" alt="{$lang.action_spam_cache}"><br>{/if}[{$lang.action_spam_cache}]</a>
            </td>
            <td class="suspected_spambody" >
            {$spamtext}
            </td>
        </tr>
        <tr>
            <td class="virusbody" align="center">
            <a href="list-cache.php{$msid}cache_type=virus">{if $use_icons}<img src="{$template_dir}images/virus.png" border="0" alt="{$lang.action_virus_cache}"><br>{/if}[{$lang.action_virus_cache}]</a>
            </td>
            <td class="virusbody" >
            {$virustext}
            </td>
        </tr>
        <tr>
            <td class="banned_filebody" align="center">
            <a href="list-cache.php{$msid}cache_type=attachment">{if $use_icons}<img src="{$template_dir}images/banned-file.png" border="0" alt="{$lang.action_banned_cache}"><br>{/if}[{$lang.action_banned_cache}]</a>
            </td>
            <td class="banned_filebody" >
            {$bannedtext}
            </td>
        </tr>
        <tr>
            <td class="bad_headerbody" align="center">
            <a href="list-cache.php{$msid}cache_type=header">{if $use_icons}<img src="{$template_dir}images/bad-header.png" border="0" alt="{$lang.action_header_cache}"><br>{/if}[{$lang.action_header_cache}]</a>
            </td>
            <td class="bad_headerbody" >
            {$headertext}
            </td>
        </tr>
        </table>
        <div class="ui-widget-header ui-corner-bottom submitrow">
            <input type="submit" name="delete_all_items" value="{$lang.button_delete_all_items}">
        </div>
        </form>
    </div>