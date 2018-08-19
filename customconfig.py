#! /usr/bin/env python
import os
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_JUSTIFY, TA_RIGHT
from reportlab.lib.units import cm
from reportlab.lib import colors

from mwlib.rl.pdfstyles import text_style as ts

title_margin_top = 8.5*cm
if os.path.isfile('/var/cache/mwlib/TitlePage.png'):
    title_page_image = '/var/cache/mwlib/TitlePage.png'
title_page_image_size = (20*cm, 28*cm)
titlepagefooter = u''
creation_date_format = '%d %b %Y'
creation_date_txt = '%s'
table_align = TA_LEFT
img_max_thumb_width = 1
img_max_thumb_height = 1
img_inline_scale_factor = 1
word_wrap = True
show_article_attribution = False
show_article_hr = False
show_wiki_license = False

fonts = [
    {'name': 'FreeSerif',
     'code_points': ['Basic Latin', 'Latin-1 Supplement', 'Latin Extended-A', 'Latin Extended-B', 'Latin Extended Additional', (64256, 64262), 'Cyrillic', 'Cyrillic Supplement', 'Cyrillic Extended-B', 'Greek Extended', 'Greek and Coptic', 'Geometric Shapes', 'Hebrew', 'Alphabetic Presentation Forms', 'Miscellaneous Symbols', 'Mathematical Alphanumeric Symbols'],
     'xl_scripts': ['Latin', 'Cyrillic', 'Greek', 'Coptic', 'Hebrew'],
     'file_names': ['freefont/FreeSerif.ttf', 'freefont/FreeSerifBold.ttf', 'freefont/FreeSerifItalic.ttf', 'freefont/FreeSerifBoldItalic.ttf'],
     },
    {'name': 'FreeSans',
     'code_points': ['IPA Extensions', 'Spacing Modifier Letters', 'Combining Diacritical Marks', 'Armenian', 'NKo', 'Lao', 'Georgian', 'Unified Canadian Aboriginal Syllabics', 'Ogham', 'Phonetic Extensions', 'Phonetic Extensions Supplement', 'Combining Diacritical Marks Supplement', 'General Punctuation', 'Superscripts and Subscripts', 'Currency Symbols', 'Combining Diacritical Marks for Symbols', 'Letterlike Symbols', 'Number Forms', 'Arrows', 'Mathematical Operators', 'Miscellaneous Technical', 'Control Pictures', 'Enclosed Alphanumerics', 'Block Elements', 'Dingbats', 'Miscellaneous Mathematical Symbols-A', 'Supplemental Arrows-A', 'Braille Patterns', 'Miscellaneous Mathematical Symbols-B', 'Supplemental Mathematical Operators', 'Miscellaneous Symbols and Arrows', 'Latin Extended-C', 'Tifinagh', 'Supplemental Punctuation', 'Yijing Hexagram Symbols', 'Modifier Tone Letters', 'Latin Extended-D', 'Variation Selectors', 'Combining Half Marks', 'Specials', 'Tai Xuan Jing Symbols', 'Mathematical Alphanumeric Symbols', 'Syriac'] ,
     'file_names': ['freefont/FreeSans.ttf', 'freefont/FreeSansBold.ttf', 'freefont/FreeSansOblique.ttf', 'freefont/FreeSansBoldOblique.ttf'],
     },
    {'name': 'FreeMono',
     'code_points': ['Box Drawing'] , # also used for code/source/etc.
     'xl_scripts': [],
     'file_names': ['freefont/FreeMono.ttf', 'freefont/FreeMonoBold.ttf', 'freefont/FreeMonoOblique.ttf', 'freefont/FreeMonoBoldOblique.ttf'],
     },
    ]

def text_style(mode='p', indent_lvl=0, in_table=0, relsize='normal', text_align=None):
    style = ts(mode, indent_lvl, in_table, relsize, text_align)
    if mode == 'booktitle':
        style.textColor = colors.HexColor('0x547392')
        style.alignment = TA_CENTER
    if mode == 'booksubtitle':
        style.textColor = colors.HexColor('0x547392')
        style.alignment = TA_CENTER
    return style
