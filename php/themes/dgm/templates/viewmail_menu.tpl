<div class="cache_submit_buttons"><p>Selected messages:</p>
<ul>
<li>
 <input name="submit" value="ham" type="submit" class="cache_submit_button_text" />
 <input name="submit" value="ham" type="image" class="cache_submit_button_image" src="{$template_dir}images/mail.png" alt="ham" />
 </li>
<li>
<input name="submit" value="spam" type="submit" class="cache_submit_button_text" />
<input name="submit" value="spam" type="image" class="cache_submit_button_image" src="{$template_dir}images/sisadmin.png" alt="ham"/>
</li>
<li>
<input name="submit" value="delete" type="submit" class="cache_submit_button_text" />
<input name="submit" value="delete" type="image" class="cache_submit_button_image" src="{$template_dir}images/trashcan_empty.png" alt="ham" />
</li>
{if $showraw}
<li>
<a href="view.php{$msid}id={$id}&amp;cache_type={$type}&amp;raw={if $raw}n{else}y{/if}">
{if $raw}Decoded{else}Raw{/if}<IMG class="cache_submit_button_image" src="{$template_dir}images/{if $raw}view-decoded.png{else}view-raw.png{/if}" alt="raw">
</a>
</li>
{/if}
<li>
 <input name="submit" value="resend" type="submit" class="cache_submit_button_text" />
 <input name="submit" value="resend" type="image" class="cache_submit_button_image" src="{$template_dir}images/redo.png" alt="ham" />
</li>

</ul>
</div>
