<tr>
<td class="{$header}" colspan="{$cols}" align="center">
<input type="submit" name="confirm" value="{$lang.button_confirm}">
</td>
</tr>

{if count($data.pages) > 1}
<tr>
<td class="{$body}" colspan="{$cols}" align="center">
{if $offset > 0}
<a href="{$return_page}{$msid}offset={$data.prev}">&lt;&lt; {$lang.link_prev} </a>&nbsp;|
{/if}
{strip}
{foreach key=page item=start from=$data.pages}
{if $start != $offset}
  <a href="{$return_page}{$msid}offset={$start}">{$page}</a>
  {else}
     {$page}
  {/if}
  {if $page < count($data.pages)}
&nbsp;|&nbsp;
   {/if}
{/foreach}
{/strip}
{if $data.to < $data.numrows}
  | <a href="{$return_page}{$msid}offset={$data.next}">{$lang.link_next}&gt;&gt;</a>
{/if}
</td>
</tr>
{/if}