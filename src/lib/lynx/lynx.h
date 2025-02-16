/*
  Lynx C port : Very-lightweight list-based UI library.
  Copyright (C) 2019 Teddy Astie (TSnake41)

  Permission to use, copy, modify, and/or distribute this software for any
  purpose with or without fee is hereby granted, provided that the above
  copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
  REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
  OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

#ifndef LYNX_H
#define LYNX_H

#include <stdint.h>
#include <stdbool.h>

#define LYNX_FOREACH_ITEM(menu, iname) \
  for (lynx_item ** iname = menu->items; (iname - menu->items) != menu->count; iname++)

typedef struct lynx_menu lynx_menu;
typedef struct lynx_item lynx_item;

typedef enum {
  LYNX_ALIGN_LEFT,
  LYNX_ALIGN_RIGHT,
  LYNX_ALIGN_CENTER
} lynx_align;

typedef enum {
  LYNX_KEY_UNDEFINED = 0,
  LYNX_KEY_UP,
  LYNX_KEY_DOWN,
  LYNX_KEY_LEFT,
  LYNX_KEY_RIGHT,
  LYNX_KEY_ENTER,
  LYNX_KEY_BEGIN,
  LYNX_KEY_END,

  LYNX_KEY_STATUS_PRESSED = 1 << 4,
  LYNX_KEY_STATUS_DOWN = 1 << 5,
  LYNX_KEY_STATUS_UP = 1 << 6,
} lynx_key;

typedef struct {
  float a, r, g, b;
} lynx_color;

typedef struct {
  void (*draw_background)(lynx_menu *, float x, float y, float w, float h);
  void (*draw_text)(lynx_menu *, const char *, lynx_color, float x, float y, float w, lynx_align);
} lynx_funcs;

struct lynx_item {
  void (*update)(lynx_item *self, lynx_menu *, float dt);
  void (*draw)(lynx_item *self, lynx_menu *, float x, float y, float w, float h);
  void (*input)(lynx_item *self, lynx_menu *, lynx_key key, unsigned int rawkey);
  void (*mouse)(lynx_item *self, lynx_menu *, float x, float y, unsigned int btn);

  bool selectable;
  float height;

  /* Type reference (kind of type id) */
  void *type;
};

struct lynx_menu {
  float x, y, w, h;
  float ox, oy;

  unsigned long current;
  lynx_color background;

  unsigned long count;
  lynx_item **items;

  lynx_funcs funcs;
  bool locked;

  #ifndef LYNX_NO_STACK
  lynx_menu *stack_top;
  void (*dtor)(lynx_menu *menu);
  #endif

  void *user;
};

void lynx_new(lynx_menu *menu);

#ifndef LYNX_NO_STACK
void lynx_push(lynx_menu *menu, lynx_menu *new);
void lynx_push_items(lynx_menu *menu, lynx_item **items, unsigned long count);
void lynx_pop(lynx_menu *menu);
#endif

void lynx_up(lynx_menu *menu);
void lynx_down(lynx_menu *menu);
lynx_item *lynx_current_item(lynx_menu *menu);

void lynx_update(lynx_menu *menu, float dt);
void lynx_draw(lynx_menu *menu);
void lynx_input_key(lynx_menu *menu, lynx_key key, int raw);
void lynx_input_mouse(lynx_menu *menu, float x, float y, unsigned int btn);

#ifdef LYNX_IMPLEMENTATION

#if !defined(LYNX_REALLOC) && !defined(LYNX_NO_STACK)
#include <stdlib.h>

#define LYNX_REALLOC realloc
#endif

#ifndef LYNX_MEMSET
/* Use a simple memset. */
void *lynx_memset(void *s, int c, size_t len)
{
  unsigned char *dst = s;

  while (len > 0) {
    *dst = (unsigned char) c;
    dst++;
    len--;
  }

  return s;
}

#define LYNX_MEMSET lynx_memset
#endif

void lynx_new(lynx_menu *menu)
{
  LYNX_MEMSET(menu, 0, sizeof(lynx_menu));

  menu->background = (lynx_color){ .25, .25, .25, .25 };
}

#ifndef LYNX_NO_STACK
void lynx_push(lynx_menu *menu, lynx_menu *new)
{
  lynx_menu *top = LYNX_REALLOC(NULL, sizeof(lynx_menu));

  if (top) {
    *top = *menu;
    *menu = *new;

    menu->stack_top = top;
  }
}

void lynx_push_items(lynx_menu *menu, lynx_item **items, unsigned long count)
{
  lynx_menu new = *menu;

  new.current = 0;
  new.items = items;
  new.count = count;

  lynx_push(menu, &new);
}

void lynx_pop(lynx_menu *menu)
{
  if (menu->stack_top) {
    /* Call menu destructor. */
    if (menu->dtor)
      menu->dtor(menu);

    lynx_menu *stack_ptr = menu->stack_top;

    /* Low cost memcpy */
    *menu = *stack_ptr;

    LYNX_REALLOC(stack_ptr, 0);
  }
}
#endif

void lynx_up(lynx_menu *menu)
{
  unsigned long old = menu->current;

  while (menu->current > 0) {
    menu->current--;
    if (lynx_current_item(menu)->selectable)
      return;
  }

  menu->current = old;
}

void lynx_down(lynx_menu *menu)
{
  unsigned long old = menu->current;

  while (menu->current < (menu->count - 1)) {
    menu->current++;
    if (lynx_current_item(menu)->selectable)
      return;
  }

  menu->current = old;
}

lynx_item *lynx_current_item(lynx_menu *menu)
{
  return menu->items[menu->current];
}

void lynx_update(lynx_menu *menu, float dt)
{
  LYNX_FOREACH_ITEM(menu, item_ptr) {
    lynx_item *item = *item_ptr;

    if (item->update)
      item->update(item, menu, dt);
  }
}

void lynx_draw(lynx_menu *menu)
{
  float x = menu->x + menu->ox;
  float y = menu->y + menu->oy;

  float w = menu->w - menu->ox;

  LYNX_FOREACH_ITEM(menu, item_ptr) {
    lynx_item *item = *item_ptr;

    if ((item_ptr - menu->items) == menu->current)
      menu->funcs.draw_background(menu, x, y, w, item->height);

    if (item->draw)
      item->draw(item, menu, x, y, w, item->height);

    y += item->height;
  }
}

void lynx_input_key(lynx_menu *menu, lynx_key key, int raw)
{
  lynx_item *current;

  if ((!menu->locked) & key & LYNX_KEY_STATUS_PRESSED) {
    /* Menu navigation */
    if (key & LYNX_KEY_UP)
      lynx_up(menu);
    else if (key & LYNX_KEY_DOWN)
      lynx_down(menu);
  }

  current = lynx_current_item(menu);

  if (current->input)
    current->input(current, menu, key, raw);
}

void lynx_input_mouse(lynx_menu *menu, float x, float y, unsigned int btn)
{
  lynx_item *current = lynx_current_item(menu);

  float vx = menu->x + menu->ox, vy = menu->y + menu->oy;
  float vw = menu->w - menu->ox, vh = menu->h - menu->oy;

  float item_y = 0;

  if (vx <= x && x <= (vx + vw) && vy <= y && y <= vy + vh) {
    /* Mouse is inside the viewport */
    if (!menu->locked)
      /* Find which item it corresponds to */
      LYNX_FOREACH_ITEM(menu, item_ptr) {
        lynx_item *item = *item_ptr;

        if (y - vy < (item_y + item->height)) {
          if (item->selectable) {
            menu->current = item_ptr - menu->items;
            current = item;
          }

          break;
        }

        item_y += item->height;
      }

    if (current->mouse)
      current->mouse(current, menu, x - vx, y - vy - item_y, btn);
  }
}

#endif

#endif
