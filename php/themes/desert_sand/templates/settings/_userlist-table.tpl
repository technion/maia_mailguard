{if $user}
<div class="styledform ui-widget-content" id="userlist-table">
<fieldset>
<legend>{$title}</legend>
<ol>
<li>
<table class="ui-list-table">
      <tr>
        {if $show_delete}
        <td class="menuheader2" align="center">{$lang.header_delete}</td>
        {/if}
        <td class="menuheader2" align="center">
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
        <td class="menubody2" align="center">{if $key == "@."}
              {$lang.text_required}
          {else}
              <input type="checkbox" name="domains[]" value="{$row.domain_id}">
          {/if}</td>
        {/if}
        <td class="menubody2" align="center"><a href="ximpersonate.php{$msid}id={$row.maia_user_id}">{$key}</a></td>
        <td class="suspected_hambody2" align="center">{$row.ham}</td>
        <td class="suspected_spambody2" align="center">{$row.spam}</td>
        <td class="virusbody2" align="center">{$row.virus}</td>
        <td class="banned_filebody2" align="center">{$row.file}</td>
        <td class="bad_headerbody2" align="center">{$row.header}</td>
      </tr>
      {/foreach}
</table>
</li>
      {if $show_delete}
          <li>
            <label for="deleteaddresses" class="extendedquestion">{$lang.text_delete_all_addresses}</label>
            <input type="checkbox" name="deleteaddresses">
          </li>
          <li class="submitrow">
          <input type="submit" name="delete" value="{$lang.button_delete}">
          </li>
      {/if}
</ol>
</fieldset>
</div>
{/if}