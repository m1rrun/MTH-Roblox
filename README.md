<div align="center">

#  Roblox Thread Holder

**A lightweight, typed, auto-cleaning thread lifecycle system for Luau**

<br/>

![Roblox](https://img.shields.io/badge/Roblox-000000?style=for-the-badge\&logo=roblox\&logoColor=white)
![Luau](https://img.shields.io/badge/Luau-00A2FF?style=for-the-badge\&logo=lua\&logoColor=white)
![Typed](https://img.shields.io/badge/Typed-Luau-8B5CF6?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-22C55E?style=for-the-badge)

</div>

## ✦ Download

<div style="line-height: 2.7;">
  <div style="display: inline-flex; align-items: center; gap: 8px;">
    <a href="https://github.com/m1rrun/MTH-Roblox/tree/main/Module">
      <img src="Assets/download_ico.svg" width="30" height="30" alt="Link to rep" style="display: block;">
    </a>
    <span style="font-size: 24px; line-height: 1; font-family: sans-serif;">You can download a ready-to-use file from here.</span>
  </div>

## Usage


```Luau
const ThreadHolder = require(path.to.ThreadHolder)
const Thread = ThreadHolder.new("Holder")

Thread:AddThread("Test", task.delay(5, function()
	print("Hi I'm a task!")
end))

```

### Or you can use

```Luau

const cache = Thread:GetAutoCache()

cache["Test"] = task.delay(5, function()
	print("Hi I'm a task!")
end)

```

## ✦ Variables

```Luau

Thread.isEmpty: boolean
  --> Returns true if there are no active threads in the list

Thread.isAutoClear: boolean
  --> Returns true if auto clear is enabled

```

## ✦ Methods

```Luau

const Thread = ThreadHolder.new(id: string?, disableAutoClear: boolean?): self
  --> Creates a new ThreadHolder class

Thread:AddThread(id: string, thread: thread): self
  --> Add a thread to list

Thread:HaveThread(id: string): boolean
  --> Return true if thread with assigned name exists

Thread:GetThread(id: string): thread?
  --> Return thread if exists

Thread:GetAutoCache(reMeta: boolean?): {[string]: thread}
  --> Returns a cache that allows direct writing and automatic clearing, bypassing standard methods

Thread:RemoveThread(id: string): self
  --> Only remove thread from list, does not close it

Thread:CancelThread(id: string): self
  --> Cancel and clear a thread

Thread:CancelAllThreads(): self
  --> Close all threads

Thread:Destroy(): nil
  --> Destroys the class, including all threads inside

```

## ✦ Settings

Settings are configured by modifying script attributes

### Attributes:

**`AutoClear_Update_Time`** --> **`number`** <br> 
&emsp;-->Sets a timer for automatic cleaning<br>
&emsp;&emsp;-->If is less than 1, the module will return an error

**`Overwrite_Old_Thread`** --> **`boolean`** <br> 
&emsp;-->Enables automatic cancel and cleanup of old thread when attempting to create a new thread with the same id<br>
&emsp;&emsp;-->If is disabled, any attempt to overwrite will result in a warn
