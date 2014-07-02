<?php
    /*
     * $Id: reportspam.php,v 1.1.2.1 2004/09/07 19:29:05 jleaver Exp $
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
     *    if and wherever such third-party acknowledgments normally appear.
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

    // Page subtitle
    $lang['banner_subtitle'] =  "Rapporter Spam";

    // Table headers
    $lang['header_suspected_ham'] =  "Mistenkt Ham";
    $lang['header_ham_cache_contents'] =  "Ham Cache Innhold";

    // Text messages
    $lang['text_item'] =  "Melding";
    $lang['text_items'] =  "Meldinger";
    $lang['text_score'] =  "Score";
    $lang['text_received'] =  "Mottatt";
    $lang['text_from'] =  "Fra";
    $lang['text_to'] =  "Til";
    $lang['text_spam'] =  "Useriøs epost?";
    $lang['text_ham'] =  "Seriøs epost?";
    $lang['text_delete'] =  "Slett";
    $lang['text_report'] =  "Useriøs epost!";
    $lang['text_subject'] =  "Tittel";
    $lang['text_no_subject'] =  "ingen tittel";
    $lang['text_empty'] =  "Din ham cache er tom.";
    $lang['text_updated'] =  "Din ham cache har blitt oppdatert.";
    $lang['text_of'] =  "av";
    $lang['text_ham_confirmed'] =  "%d mulig seriøse epostmeldinger ble bekreftet";
    $lang['text_spam_reported'] =  "%d mulige seriøse epostmeldinger ble rapportert som spam";
    $lang['text_suspected_ham_item'] =  "Mulig seriøs epostmelding";
    $lang['text_suspected_ham_items'] =  "Mulige seriøse epostmeldinger";

    // Buttons
    $lang['button_confirm_ham'] =  "ALLE meldinger i denne listen er seriøse meldinger";
    $lang['button_confirm'] =  "Bekreft statusen på alle disse meldingene";
    $lang['button_delete_all_cached_items'] =  "Slett ALLE lagrede meldinger";

    // Link text
    $lang['link_prev'] =  "Forrige";
    $lang['link_next'] =  "Nest";
    $lang['link_report_spam'] =  "Tilbake til Ham Cache menyen";
?>
