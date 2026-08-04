package com.nekara.client.mixin;

import net.minecraft.client.gui.GuiGraphicsExtractor;
import net.minecraft.client.renderer.Panorama;
import net.minecraft.client.renderer.RenderPipelines;
import net.minecraft.resources.Identifier;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Panorama.class)
abstract class PanoramaMixin {
	private static final Identifier NEKARA_STATIC_BACKGROUND =
		Identifier.fromNamespaceAndPath("nekara", "textures/gui/title/static_background.png");
	private static final int BACKGROUND_TEXTURE_WIDTH = 1456;
	private static final int BACKGROUND_TEXTURE_HEIGHT = 816;

	@Inject(method = "extractRenderState", at = @At("HEAD"), cancellable = true)
	private void nekara$renderStaticBackground(
		final GuiGraphicsExtractor graphics,
		final int width,
		final int height,
		final boolean shouldSpin,
		final CallbackInfo callback
	) {
		int sourceX = 0;
		int sourceY = 0;
		int sourceWidth = BACKGROUND_TEXTURE_WIDTH;
		int sourceHeight = BACKGROUND_TEXTURE_HEIGHT;

		long scaledTextureWidth = (long) BACKGROUND_TEXTURE_WIDTH * height;
		long scaledTextureHeight = (long) BACKGROUND_TEXTURE_HEIGHT * width;
		if (scaledTextureWidth > scaledTextureHeight) {
			sourceWidth = Math.max(1, BACKGROUND_TEXTURE_HEIGHT * width / height);
			sourceX = (BACKGROUND_TEXTURE_WIDTH - sourceWidth) / 2;
		} else if (scaledTextureWidth < scaledTextureHeight) {
			sourceHeight = Math.max(1, BACKGROUND_TEXTURE_WIDTH * height / width);
			sourceY = (BACKGROUND_TEXTURE_HEIGHT - sourceHeight) / 2;
		}

		graphics.blit(
			RenderPipelines.GUI_TEXTURED,
			NEKARA_STATIC_BACKGROUND,
			0,
			0,
			sourceX,
			sourceY,
			width,
			height,
			sourceWidth,
			sourceHeight,
			BACKGROUND_TEXTURE_WIDTH,
			BACKGROUND_TEXTURE_HEIGHT
		);
		callback.cancel();
	}
}
