defmodule Qrstorage.ApiCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the API for TTS.
  """
  import Mox

  use ExUnit.CaseTemplate

  using do
    quote do
      import Qrstorage.ApiCase

      import Mox
      setup :verify_on_exit!
    end
  end

  def mockTtsServiceSuccess(mock_file_content \\ "mock audio file content", translated_text \\ "translated text") do
    Qrstorage.Services.Tts.TextToSpeechApiServiceMock
    |> expect(:text_to_audio, fn _text, _language, _voice ->
      {:ok, mock_file_content}
    end)

    mock_language_service_success(translated_text)

    mock_file_content
  end

  def mockTtsServiceError() do
    Qrstorage.Services.Tts.TextToSpeechApiServiceMock
    |> expect(:text_to_audio, fn _text, _language, _voice ->
      {:error, "error"}
    end)

    Qrstorage.Services.Translate.TranslateApiServiceMock
    |> expect(:translate, fn _text, _language ->
      {:ok, "translated text"}
    end)
  end

  def mockLanguageServiceError() do
    Qrstorage.Services.Translate.TranslateApiServiceMock
    |> expect(:translate, fn _text, _language ->
      {:error, "text not translated"}
    end)
  end

  def mock_language_service_success(translated_text \\ "translated text") do
    Qrstorage.Services.Translate.TranslateApiServiceMock
    |> expect(:translate, fn _text, _language ->
      {:ok, translated_text}
    end)
  end
end
