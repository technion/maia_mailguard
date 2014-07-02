{if $user}
<table border="0" cellspacing="2" cellpadding="2" width="600">
  <tr><th class="menubanner" align="center" colspan="{$cols}">{$title}</th></tr>
      <tr>
        {if $show_delete}
        <td class="menuheader" align="center">{$lang.header_delete}</td>
        {/if}
        <td class="menuheader" align="center">
          {$user_header}
        </td>
        <td class="suspected_hambody3" align="center">{$lang.ham_header}</td>
        <td class="suspected_spambody3" align="center">{$lang.spam_header}</td>
        <td class="virusbody3" align="center">{$lang.virus_header}</td>
        <td class="banned_filebody3" align="center">{$lang.banned_header}</td>
        <td class="bad_headerbody3" align="center">{$lang.badheader_header}</td>
      </tr>
      {foreach from=$user key=key item=row}
      <tr>
        {if $show_delete}
        <td class="menubody" align="center">{if $key == "@."}
              {$lang.text_required}
          {else}
              <input type="checkbox" name="domains[]" value="{$row.domain_id}">
          {/if}</td>
        {/if}
        <td class="menubody" align="center"><a href="ximpersonate.php{$msid}id={$row.maia_user_id}">{$key}</a></td>
        <td class="suspected_hambody2" align="center">{$row.ham}</td>
        <td class="suspected_spambody2" align="center">{$row.spam}</td>
        <td class="virusbody2" align="center">{$row.virus}</td>
        <td class="banned_filebody2" align="center">{$row.file}</td>
        <td class="bad_headerbody2" align="center">{$row.header}</td>
      </tr>
      {/foreach}
      {if $show_delete}
          <tr>
            <td class="menubody" align="center" colspan="7">
              <label for="deleteaddresses" class="extendedquestion">{$lang.text_delete_all_addresses}</label>
              <input type="checkbox" name="deleteaddresses">
            </td>
          </tr>
          <tr>
          <td class="menubody" align="center" colspan="7">
          <input type="submit" name="delete" value=" {$lang.button_delete} ">
          </td>
          </tr>
      {/if}
</table>
{/if}