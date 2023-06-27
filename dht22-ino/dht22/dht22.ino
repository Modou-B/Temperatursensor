#include "ArduinoJson.h"
#include "DHTesp.h"
#include <PubSubClient.h>
#include <ESP8266WiFi.h>

const char* _SSID = "FRITZ!Box 6660 Cable EF";
const char* _Password = "21006767553113784465";
const char* mqtt_server = "192.168.178.38"; // generiert aus 0.0.0.1 in der mosquitto.conf = 1883 0.0.0.1

WiFiClient espClient;
PubSubClient client(espClient);

unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE	(50)
char msg[MSG_BUFFER_SIZE];
int value = 0;




const int DHT_PIN = 4;
DHTesp dhtSensor;


//TOPICS
const char* START_TOPIC = "dht/start";
const char* STOP_TOPIC = "dht/stop";
const char* RESTART_TOPIC = "dht/restart";
const char* TEMP_TOPIC = "dht/temp";
const char* HUMIDITY_TOPIC = "dht/humidity";

// Topic Values
int stopScript = 0;
int startScript = 0;
int restartScript = 0;

//INIT TOPIC VARS
StaticJsonDocument<50> temp;
char tempMessage[25];

StaticJsonDocument<50> humidity;
char humidityMessage[25];



void callback(char* topic, byte* payload, unsigned int length) 
{
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  
  if (strcmp(topic, START_TOPIC) == 0){    
    Serial.print("asdhasd, rc=");

    int startValue = (char)payload[0] - '0';
    startScript = startValue;
    
    stopScript = 0;
    restartScript = 0;
  }

  if (strcmp(topic, STOP_TOPIC) == 0) {
    int stopValue = (char)payload[0] - '0';
    stopScript = stopValue;

    startScript = 0;
    restartScript = 0;
  }

  if (strcmp(topic, RESTART_TOPIC) == 0) {
    int restartValue = (char)payload[0] - '0';
    restartScript = restartValue;
  }

  for (int i = 0; i < length; i++) 
  {
    Serial.print((char)payload[i]);
  }
  
  Serial.println();

  // Switch on the LED if an 1 was received as first character
  if ((char)payload[0] == '1') 
  {
    digitalWrite(LED_BUILTIN, LOW);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because
    // it is active low on the ESP-01)
  } else 
  {
    digitalWrite(LED_BUILTIN, HIGH);  // Turn the LED off by making the voltage HIGH
  }
}




void setup_wifi() 
{

  // We start by connecting to a WiFi network
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(_SSID);

  WiFi.mode(WIFI_STA);
  WiFi.begin(_SSID, _Password);

  while (WiFi.status() != WL_CONNECTED) 
  {
    delay(500);
    Serial.print(".");
  }
  
  randomSeed(micros());
  
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  
}



void reconnect() 
{
  while (!client.connected()) 
  {
    delay(10000);
    Serial.print("Attempting MQTT connection...");
  
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);
    
    if (client.connect(clientId.c_str())) 
    {
      Serial.println("connected");

      client.subscribe(START_TOPIC);
      client.subscribe(STOP_TOPIC);
      client.subscribe(RESTART_TOPIC);
      client.subscribe(TEMP_TOPIC);
      client.subscribe(HUMIDITY_TOPIC);    
    } else 
    {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}




void setup() 
{
  Serial.begin(115200);
  dhtSensor.setup(DHT_PIN, DHTesp::DHT22);
  setup_wifi();

  pinMode(LED_BUILTIN, OUTPUT);    // Initialize the LED_BUILTIN pin as an output

  
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}




void loop() 
{
  
  if (!client.connected()) {
    reconnect();
  }

  client.loop();
  
  if (restartScript == 1) {
    // vllt hier beim restatt die temp history löschen oder so
      stopScript = 0;

      if (startScript == 1) {
        startScript = 0;
      } else {
        startScript = 1;
      }
  }

  if (startScript == 1) { // 1
    TempAndHumidity  data = dhtSensor.getTempAndHumidity();
    Serial.println("Temp: " + String(data.temperature, 2) + "°C");
    

    temp["temp"] = data.temperature;
    serializeJson(temp, tempMessage);
    client.publish(TEMP_TOPIC, tempMessage);


    Serial.println("Humidity: " + String(data.humidity, 1) + "%");

    humidity["humidity"] = data.humidity;
    serializeJson(humidity, humidityMessage);
    client.publish(HUMIDITY_TOPIC, humidityMessage);
    Serial.println("---");
    if (restartScript == 1) {
      restartScript = 0;
    }
    delay(8000);
  }
}