<?php
    /*
     * $Id$
     *
     * MAIA MAILGUARD LICENSE v.1.0
     *
     * Copyright 2004 by Robert LeBlanc <rjl@renaissoft.com>
     * All rights reserved.
     *
     * PREAMBLE
     *
     * This License is designed for users of Maia Mailguard
     * ("the Software") who wish to support the Maia Mailguard project by
     * leaving "Maia Mailguard" branding information in the HTML output
     * of the pages generated by the Software, and providing links back
     * to the Maia Mailguard home page.  Users who wish to remove this
     * branding information should contact the copyright owner to obtain
     * a Rebranding License.
     *
     * DEFINITION OF TERMS
     *
     * The "Software" refers to Maia Mailguard, including all of the
     * associated PHP, Perl, and SQL scripts, documentation files, graphic
     * icons and logo images.
     *
     * GRANT OF LICENSE
     *
     * Redistribution and use in source and binary forms, with or without
     * modification, are permitted provided that the following conditions
     * are met:
     *
     * 1. Redistributions of source code must retain the above copyright
     *    notice, this list of conditions and the following disclaimer.
     *
     * 2. Redistributions in binary form must reproduce the above copyright
     *    notice, this list of conditions and the following disclaimer in the
     *    documentation and/or other materials provided with the distribution.
     *
     * 3. The end-user documentation included with the redistribution, if
     *    any, must include the following acknowledgment:
     *
     *    "This product includes software developed by Robert LeBlanc
     *    <rjl@renaissoft.com>."
     *
     *    Alternately, this acknowledgment may appear in the software itself,
     *    if and wherver such third-party acknowledgments normally appear.
     *
     * 4. At least one of the following branding conventions must be used:
     *
     *    a. The Maia Mailguard logo appears in the page-top banner of
     *       all HTML output pages in an unmodified form, and links
     *       directly to the Maia Mailguard home page; or
     *
     *    b. The "Powered by Maia Mailguard" graphic appears in the HTML
     *       output of all gateway pages that lead to this software,
     *       linking directly to the Maia Mailguard home page; or
     *
     *    c. A separate Rebranding License is obtained from the copyright
     *       owner, exempting the Licensee from 4(a) and 4(b), subject to
     *       the additional conditions laid out in that license document.
     *
     * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
     * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
     * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
     * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
     * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
     * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
     * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
     * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
     * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
     * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
     * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
     *
     */
    $lang['text_welcome_greeting'] = "Velkommen til Maia Mailguard!";
    $lang['text_welcome_first_time'] = "Velkommen til Maia Mailguard. Jeg ser at dette er første gang du er logget på. Læs venligst hele denne besked, da du kan hjælpe i krigen mod spam.<P>
                                        for det første, tænd dit filter nu, ved at vælge et niveau herunder og klik på \"Skift niveau\".  \"høj\" er rigtig sikkert, og det vi anbefaler.
                                        <P>Maia Mailguard kan filtrere dine emails, og blokere langt det meste uønskede, fra at ende i din postkasse.  Hvis der dog skulle ske en fejl, kan den hurtigt rettes.
                                        Maia kan sætte dine emails i \"karantæne\", de vil dog være tilgængelige på denne side. Når emails er røget i karantæne, kan du her \"redde\" eller \"rapportere\" dem. Ved at redde emails, får du dem leveret i din postkasse. Når du rapportere emails fra din \"ikke-spam\" mappe, hjælper du rigtig mange mennesker rundt om i verden imod at modtage lige netop den spammail, og selvfølgelig visa versa.";
    $lang['text_welcome_intro'] = "<p>Slå igen mod de sygelige mængder af uønsket mail med Maia Mailguard.  Når der er emails listet i bunden af denne side, kan du træne Maia til at enten blokere lignende emails, eller godkende dem fremover. Vær venligst opmærksom på at de emails du rapportere som SPAM, faktisk er spam og ikke blot en mail der er blevet sendt til dig ved en fejl. Hvis du ikke har tid til at rapportere spam mails, da slet dem istedet for at rapportere dem som værende spam.<p>
                                    Hav for øje, at Maia rapportere bekræftet spam til andre organisationer. Ved at rapportere en masse spam, hjælper du aktivt til i kampen mod spam.";
    $lang['text_welcome_current_level'] = "Nuværende beskyttelses niveau:"; 
    $lang['text_welcome_custom_level'] = "**Custom levels are in use:<br>Use settings screen to manage, or choose a preset level above.";
   
    $lang['text_welcome_spam_blocked'] = "SPAM emails blokeret for dig";
    $lang['text_welcome_virus_blocked'] = "Vira stoppet for dig";
    $lang['text_welcome_spam_blocked_system'] = "Spam emails blokeret for hele systemet";
    $lang['text_welcome_virus_blocked_system'] = "Vira stoppet for hele systemet";
    $lang['button_delete_all_items'] = "Slet alle emails";
    $lang['button_change_protection'] = "Skift niveau";
    
    $lang['radio_protection'] = array(  'off' => "Slukket",
		 								'low' => "Lav",
     									'medium' => "Mellem",
										'high' => "Høj",
										'custom' => "Skræddersyet");
    
    $lang['banner_subtitle'] = "Velkommen";
    
    $lang['text_cache_spam'] = "Du har <b>%d</b> emails i din spam mappe.  <br>Klik <a href=\"%s\">her</a> for at rapportere den, eller redde en mail som ved en fel er blevet blokeret.";
    $lang['text_cache_virus'] = "Du har <b>%d</b> emails i din  virus mappe.  <br>Klik <a href=\"%s\">her</a> for at slette den, eller redde en mail som ved en fejl er blevet blokeret.";
    $lang['text_cache_banned'] = "Du har <b>%d</b> filer i din blokerede fil mappe.  <br>Klik <a href=\"%s\">her</a> for at slette den, eller redde en fil som ved en fejl er blevet blokeret.";
    
    $lang['text_cache_header'] = "Du har <b>%d</b> emails i dine ukorrekte headere mappe.  <br>Klik <a href=\"%s\">her</a> for at slette den, eller redde en mail som ved en fejl er blevet blokeret.";
    $lang['text_cache_ham'] = "Du har <b>%d</b> emails i din ikke-spam mappe.  <br>Klik <a href=\"%s\">her</a> for at træne AntiSpam filtret, eller rapportere en mail som værende spam, som ikke blev fanget af systemet.";
    $lang['action_ham_cache']   = "Rapporter/Bekræft";
    $lang['action_spam_cache']  = "Rapporter/Red";
    $lang['action_virus_cache'] = "Slet/Red";
    $lang['action_banned_cache'] = "Slet/Red";
    $lang['action_header_cache'] = "Slet/Red";
